#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyImagesLin
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vSW1hZ2VzLw==
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyImagesMac
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vSW1hZ2VzLw==
				End
				Begin IDEScriptBuildStep EnableRetina , AppliesTo = 0
					Var App As String = CurrentBuildLocation + "/""" + CurrentBuildAppName + ".app"""
					Call DoShellCommand("/usr/bin/defaults write " + App + "/Contents/Info ""NSHighResolutionCapable"" YES")
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyImagesWin
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vSW1hZ2VzLw==
				End
			End
#tag EndBuildAutomation
