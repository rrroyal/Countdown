//
//  NewCountdownView.swift
//  Countdown
//
//  Created by royal on 11/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import SwiftUI

struct NewCountdownView: View {
	@EnvironmentObject var Store: StoreModel
	@Binding var isPresented: Bool
	
	@State var isDatePickerDayVisible: Bool = false
	@State var isDatePickerHourVisible: Bool = false
	
	@State var countdown: Countdown?
	@State var countdownTitle: String = ""
	@State var countdownIcon: String = ""
	@State var countdownColorHex: String = ""
	@State var countdownDate: Date = Date().withoutSeconds
	
	var countdownColor: UIColor? {
		get {
			return UIColor(hex: self.countdownColorHex)
		}
		set(value) {
			guard let hex: String = value?.hex else {
				return
			}
			self.countdownColorHex = hex
		}
	}
	
	var isAddButtonEnabled: Bool {
		get {
			return !self.countdownTitle.isEmpty
		}
	}
	
    var body: some View {
		let randomHex: String = "#" + String((0..<6).map { _ in "0123456789ABCDEF".randomElement()! })
		
		return VStack {
			Spacer()
			
			// Title
			Group {
				VStack(alignment: .leading) {
					Text("Title")
						.font(.title)
						.bold()
						.padding(.horizontal, 2)
					
					TextField("WWDC", text: $countdownTitle)
						.font(.headline)
						.padding()
						.withBackground()
						.onTapGesture {
							return
					}
				}
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
				
				Spacer()
			}
			
			// Color
			Group {
				VStack(alignment: .leading) {
					Text("Color")
						.font(.title)
						.bold()
						.padding(.horizontal, 2)
					
					HStack {
						TextField(randomHex, text: self.$countdownColorHex) {
							if (self.countdownColorHex.isEmpty) {
								self.countdownColorHex = randomHex
							}
						}
						.disableAutocorrection(true)
						.font(.headline)
						.padding()
						.onTapGesture {
							return
						}
						Rectangle()
							.fill(Color(self.countdownColor ?? UIColor.clear))
							.frame(width: 70)
							.opacity(self.countdownColor != nil ? 1 : 0)
							.disabled(self.countdownColor == nil)
							.onDrag {
								let provider = NSItemProvider(object: (self.countdownColor ?? UIColor()))
								provider.suggestedName = self.countdownColor?.hex
								return provider
						}
					}
					.withBackground()
					.onDrop(of: ["com.apple.uikit.color"], isTargeted: nil) { (items) in
						if let item = items.first {
							_ = item.loadObject(ofClass: UIColor.self) { (color, _) in
								if let color = color as? UIColor {
									guard let hex: String = color.hex else {
										return
									}
									self.countdownColorHex = hex
								}
							}
						}
						
						return true
					}
				}
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
				
				Spacer()
			}
			
			// Icon
			Group {
				VStack(alignment: .leading) {
					Text("Icon")
						.font(.title)
						.bold()
						.padding(.horizontal, 2)
					
					HStack {
						TextField("staroflife.fill", text: self.$countdownIcon)
							.disableAutocorrection(true)
							.font(.headline)
							.padding()
							.onTapGesture {
								return
						}
						Image(systemName: self.countdownIcon)
							.foregroundColor(self.countdownColor == nil ? Color.primary : Color(self.countdownColor ?? UIColor.clear))
							.padding(.horizontal)
							.id(self.countdownIcon)
							.transition(.opacity)
							.animation(.easeInOut)
					}
					.withBackground()
				}
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
				
				Spacer()
			}
			
			// Date
			Group {
				VStack(alignment: .leading) {
					Text("Date")
						.font(.title)
						.bold()
						.padding(.horizontal, 2)
						.padding(.bottom)
					
					HStack {
						// Day
						Button(action: {
							self.isDatePickerDayVisible.toggle()
							self.isDatePickerHourVisible = false
						}) {
							Spacer()
							Text(self.countdownDate.string(format: "dd/MM/yyyy"))
								.font(.headline)
								.id("\(self.countdownDate):\(self.countdownColor?.hex ?? "")")
								.animation(.easeInOut)
								.transition(.opacity)
							Spacer()
						}
						.padding()
						.background(self.isDatePickerDayVisible ? Color(UIColor.systemGray5) : nil)
												
						// Hour
						Button(action: {
							self.isDatePickerDayVisible = false
							self.isDatePickerHourVisible.toggle()
						}) {
							Spacer()
							Text(self.countdownDate.string(format: "HH:mm"))
								.font(.headline)
								.id("\(self.countdownDate):\(self.countdownColor?.hex ?? "")")
								.animation(.easeInOut)
								.transition(.opacity)
							Spacer()
						}
						.padding()
						.background(self.isDatePickerHourVisible ? Color(UIColor.systemGray5) : nil)
					}
					.withBackground()
					
					if (self.isDatePickerDayVisible && !self.isDatePickerHourVisible) {
						// Day
						HStack {
							Spacer()
							DatePicker("", selection: $countdownDate, displayedComponents: .date)
								.datePickerStyle(WheelDatePickerStyle())
								.labelsHidden()
							Spacer()
						}
					} else if (!self.isDatePickerDayVisible && self.isDatePickerHourVisible) {
						// Hour
						HStack {
							Spacer()
							DatePicker("", selection: $countdownDate, displayedComponents: .hourAndMinute)
								.datePickerStyle(WheelDatePickerStyle())
								.labelsHidden()
							Spacer()
						}
					}
				}
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
				
				Spacer()
			}
			
			// Add button
			Group {
				Button(action: {
					if (self.countdown != nil) {
						// Editing
						self.countdown?.title = self.countdownTitle
						self.countdown?.icon = self.countdownIcon
						self.countdown?.color = self.countdownColor
						self.countdown?.date = self.countdownDate
					} else {
						// New
						let countdown: Countdown = Countdown(title: self.countdownTitle, icon: self.countdownIcon, colorHex: self.countdownColor?.hex, date: self.countdownDate)
						self.Store.addCountdown(countdown)
					}
					generateHaptic(.light)
					self.isPresented = false
				}) {
					HStack {
						Group {
							if (self.countdown != nil) {
								Image(systemName: "pencil")
								Text("Edit")
							} else {
								Image(systemName: "plus")
								Text("Add")
							}
						}
					}
					.customButton(self.countdownColor == nil ? Color.accentColor : Color(self.countdownColor ?? UIColor()), enabled: self.isAddButtonEnabled)
				}
				.disabled(!self.isAddButtonEnabled)
			}
		}
		.padding()
		.contentShape(Rectangle())
		.accentColor(self.countdownColor == nil ? Color.accentColor : Color(self.countdownColor ?? UIColor.clear))
		.onTapGesture {
			UIApplication.shared.endEditing()
			self.isDatePickerDayVisible = false
			self.isDatePickerHourVisible = false
		}
		.modifier(AdaptsToSoftwareKeyboard())
		.onAppear {
			if (self.countdown != nil) {
				self.countdownTitle = self.countdown?.title ?? ""
				self.countdownIcon = self.countdown?.icon ?? ""
				self.countdownColorHex = self.countdown?.color?.hex ?? ""
				self.countdownDate = self.countdown?.date ?? Date()
			}
		}
    }
}

struct NewCountdownView_Previews: PreviewProvider {
    static var previews: some View {
		NewCountdownView(isPresented: .constant(true))
    }
}
