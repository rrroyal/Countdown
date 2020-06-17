//
//  ContentView.swift
//  Countdown
//
//  Created by royal on 11/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
	@EnvironmentObject var Timer: AppTimer
	@EnvironmentObject var Store: StoreModel
	@State var isSheetPresented: Bool = false
	
	@State var activeCountdown: Countdown?
	@State var nowDate: Date = Date()
	
	var listView: some View {
		List {
			ForEach(self.Store.countdowns) { countdown in
				CountdownCell(countdown: countdown, now: self.nowDate)
					.contextMenu {
						// Edit
						Button(action: {
							self.activeCountdown = countdown
							self.isSheetPresented = true
						}) {
							Text("Edit")
							Image(systemName: "pencil")
						}
						
						// Copy date
						Button(action: {
							UIPasteboard.general.string = "\(countdown.title): \(countdown.date)"
							generateHaptic(.light)
						}) {
							Text("Copy date")
							Image(systemName: "doc.on.doc")
						}
						
						// Delete
						Button(action: {
							guard let index = self.Store.countdowns.firstIndex(of: countdown) else {
								return
							}
							self.Store.removeCountdown(at: index)
							generateHaptic(.light)
						}) {
							Text("Delete")
							Image(systemName: "trash")
						}
					}
					.listRowBackground(Color(countdown.color ?? UIColor.clear).opacity(0.1))
					.contentShape(Rectangle())
					.id("\(countdown.id):\(countdown.color ?? UIColor())")
			}
			.onDelete { (indexSet) in
				indexSet.forEach { index in
					self.Store.removeCountdown(at: index)
				}
				generateHaptic(.light)
			}
		}
	}
	
    var body: some View {
		NavigationView {
			Group {
				if (self.Store.countdowns.count > 0) {
					listView
						.environment(\.horizontalSizeClass, .regular)
						.listStyle(GroupedListStyle())
						.onAppear {
							if (self.Store.countdowns.count > 0) {
								self.Timer.start()
							}
						}
						.onReceive(Timer.timeChanged) {
							if (self.Store.countdowns.count == 0) {
								return
							}
							
							generateHaptic(.selectionChanged)
							self.nowDate = Date()
						}
				} else {
					Text("No countdowns")
						.opacity(0.3)
				}
			}
			.navigationBarTitle(Text("Countdowns"))
			.navigationBarItems(trailing:
				Button(action: {
					self.activeCountdown = nil
					self.isSheetPresented.toggle()
				}) {
					Image(systemName: "plus")
						.navigationBarButton(edge: .trailing)
				}
			)
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onReceive(Store.countdownsUpdated) { (count) in
			if (count > 0) {
				self.Timer.start()
			} else {
				self.Timer.invalidate()
			}
		}
		.sheet(isPresented: $isSheetPresented) {
			NewCountdownView(isPresented: self.$isSheetPresented, countdown: self.activeCountdown)
				.environmentObject(self.Store)
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
