//
//  HomeView.swift
//  ChartsDemo
//
//  Created by Aybars Acar on 11/5/2023.
//

import SwiftUI
import Charts

struct HomeView: View {
  
  @State private var currentTab: String = "7 Days"
  @State private var isLineGraph = false
  
  // Gesture Properties
  @State private var currentActiveItem: SiteView?
  
  // Chart state
  @State private var sampleAnalytics = Sample.analyticsData
  
  var body: some View {
    NavigationStack {
      VStack {
        // New Charts API
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Text("Views")
              .fontWeight(.semibold)
            
            Picker("", selection: $currentTab) {
              Text("7 Days")
                .tag("7 Days")
              
              Text("Week")
                .tag("Week")
              
              Text("Month")
                .tag("Month")
            }
            .pickerStyle(.segmented)
            .padding(.leading)
          }
          
          let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
            item.views + partialResult
          }
          
          Text(totalValue.stringFormat)
            .font(.largeTitle.bold())
          
          AnimatedChart()
        }
        .padding()
        .background {
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(.white.shadow(.drop(radius: 2)))
        }
        
        Toggle("Line Graph", isOn: $isLineGraph)
          .padding(.top)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .padding()
      .navigationTitle("Swift Charts")
      .onChange(of: currentTab) { newValue in
        sampleAnalytics = Sample.analyticsData
        
        if newValue != "7 Days" {
          for (index, _) in sampleAnalytics.enumerated() {
            sampleAnalytics[index].views = .random(in: 1500...10000)
          }
        }
        
        // Reanimating view
        animateGraph(fromChange: true)
      }
    }

  }
}

private extension HomeView {
  
  @ViewBuilder
  func AnimatedChart() -> some View {
    
    let max = sampleAnalytics.max { item1, item2 in
      return item2.views > item1.views
    }?.views ?? 0
    
    Chart {
      ForEach(sampleAnalytics) { item in
        
        if isLineGraph {
          LineMark(
            x: .value("Hour", item.hour, unit: .hour),
            y: .value("Views", item.animate ? item.views : 0)
          )
          .foregroundStyle(.blue.gradient)
          .interpolationMethod(.catmullRom)
          
          AreaMark (
            x: .value("Hour", item.hour, unit: .hour),
            y: .value("Views", item.animate ? item.views : 0)
          )
          .foregroundStyle(.blue.opacity(0.1).gradient)
          .interpolationMethod(.catmullRom)
        }
        else {
          // Bar Graph
          BarMark(
            x: .value("Hour", item.hour, unit: .hour),
            y: .value("Views", item.animate ? item.views : 0)
          )
          .foregroundStyle(.blue.gradient)
        }
        
        // Rule Mark for currently dragging item
        if let currentActiveItem, currentActiveItem.id == item.id {
          RuleMark(x: .value("Hour", currentActiveItem.hour, unit: .hour))
            .lineStyle(StrokeStyle(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
            .annotation(position: .top) {
              VStack(alignment: .leading, spacing: 6) {
                Text("Views")
                  .font(.caption)
                  .foregroundColor(.gray)
                
                Text(currentActiveItem.views.stringFormat)
                  .font(.title3.bold())
              }
              .padding(.horizontal, 10)
              .padding(.vertical, 4)
              .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                  .fill(.white.shadow(.drop(radius: 2)))
              }
            }
        }
      }
    }
    // Customising Y-Axis
    .chartYScale(domain: [0, max + 5000])
    .chartOverlay(content: { proxy in
      GeometryReader { innerProxy in
        Rectangle()
          .fill(.clear).contentShape(Rectangle())
          .gesture(
            DragGesture()
              .onChanged { value in
                // getting current location
                let location = value.location
                //extracting value from teh location
                if let date: Date = proxy.value(atX: location.x) {
                  let calendar = Calendar.current
                  let hour = calendar.component(.hour, from: date)
                  if let currentItem = sampleAnalytics.first(where: { item in
                    calendar.component(.hour, from: item.hour) == hour
                  }) {
                    self.currentActiveItem = currentItem
                  }
                }
              }
              .onEnded { value in
                self.currentActiveItem = nil
              }
          )
      }
    })
    .frame(height: 250)
    .onAppear {
      animateGraph()
    }
  }
  
  func animateGraph(fromChange: Bool = false) {
    for (index, _) in sampleAnalytics.enumerated() {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
        withAnimation(fromChange ? .easeIn(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
          sampleAnalytics[index].animate = true
        }
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}


extension Double {
  var stringFormat: String {
    if self > 1000 && self < 999999 {
      return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
    }
    
    if self > 999999 {
      return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
    }

    return String(format: "%.0f", self)
  }
}
