#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyImages
					AppliesTo = 0
					Destination = 0
					Subdirectory = Images
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBEb2N1bWVudC5wbmc=
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBEb2N1bWVudEAyeC5wbmc=
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBIb21lLnBuZw==
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBIb21lQDJ4LnBuZw==
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin IDEScriptBuildStep EnableRetina , AppliesTo = 0
					Dim App As String = CurrentBuildLocation + "/""" + CurrentBuildAppName + ".app"""
					Call DoShellCommand("/usr/bin/defaults write " + App + "/Contents/Info ""NSHighResolutionCapable"" YES")
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyImages
					AppliesTo = 0
					Destination = 0
					Subdirectory = Images
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBEb2N1bWVudC5wbmc=
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBEb2N1bWVudEAyeC5wbmc=
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBIb21lLnBuZw==
					FolderItem = Li4ALi4ALi4AWmlyY29uS2l0AGJyZWFkY3J1bWJzAHRydW5rAEltYWdlcwBIb21lQDJ4LnBuZw==
				End
			End
#tag EndBuildAutomation
