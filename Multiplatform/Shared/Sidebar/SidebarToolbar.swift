//
//  SidebarToolbar.swift
//  Multiplatform iOS
//
//  Created by Stuart Breckenridge on 30/6/20.
//  Copyright © 2020 Ranchero Software. All rights reserved.
//

import SwiftUI


struct SidebarToolbar: ViewModifier {
    
	@EnvironmentObject private var appSettings: AppDefaults
	@StateObject private var viewModel = SidebarToolbarModel()

	@ViewBuilder func body(content: Content) -> some View {
		#if os(iOS)
		content
			.toolbar {
				ToolbarItem(placement: .automatic) {
					Button(action: {
						viewModel.sheetToShow = .settings
					}, label: {
						AppAssets.settingsImage
							.font(.title3)
							.foregroundColor(.accentColor)
						Spacer()
					}).help("Settings")
				}
				
				ToolbarItem(placement: .automatic, content: {
					Spacer()
					Text("Last updated")
						.font(.caption)
						.foregroundColor(.secondary)
					Spacer()
				})
				
				ToolbarItem(placement: .automatic, content: {
					Button(action: {
						viewModel.showActionSheet = true
					}, label: {
						Spacer()
						AppAssets.addMenuImage
							.font(.title3)
							.foregroundColor(.accentColor)
					})
					.help("Add")
					.actionSheet(isPresented: $viewModel.showActionSheet) {
						ActionSheet(title: Text("Add"), buttons: [
							.cancel(),
							.default(Text("Add Web Feed"), action: { viewModel.sheetToShow = .web }),
							.default(Text("Add Twitter Feed")),
							.default(Text("Add Reddit Feed")),
							.default(Text("Add Folder"))
						])
					}
				})
				
			}
			.sheet(isPresented: $viewModel.showSheet, onDismiss: { viewModel.sheetToShow = .none }) {
				if viewModel.sheetToShow == .web {
					AddWebFeedView()
				}
				if viewModel.sheetToShow == .settings {
					SettingsView().modifier(PreferredColorSchemeModifier(preferredColorScheme: appSettings.userInterfaceColorPalette))
				}
			}
		#else
		content
			.toolbar {
				ToolbarItem {
					Spacer()
				}
			}
		#endif
	}
}

