#tag Class
Protected Class ZirconBreadcrumbs
Inherits ArtisanKit.Control
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  Self.mMouseDownPoint = New Xojo.Point(X,Y)
		  Var CellIndex As Integer = Self.CellIndexForPoint(Self.mMouseDownPoint)
		  If CellIndex = -1 Then
		    Return True
		  End If
		  
		  Self.mMouseDownIndex = CellIndex
		  Self.mMouseDown = True
		  Self.Invalidate
		  Self.mHoldTimer = New Timer
		  Self.mHoldTimer.Period = 750
		  Self.mHoldTimer.RunMode = Timer.RunModes.Single
		  AddHandler mHoldTimer.Action, AddressOf HoldTimerAction
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  If Not Self.mMouseDown Then
		    Return
		  End If
		  
		  If X < Self.mMouseDownPoint.X -5 Or X > Self.mMouseDownPoint.X + 5 Or Y < Self.mMouseDownPoint.Y - 5 Or Y > Self.mMouseDownPoint.Y + 5 Then
		    If Self.mHoldTimer <> Nil Then
		      RemoveHandler mHoldTimer.Action, AddressOf HoldTimerAction
		      Self.mHoldTimer.RunMode = Timer.RunModes.Off
		      Self.mHoldTimer = Nil
		    End If
		    Self.mMouseDown = False
		    Self.Invalidate
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  If Not Self.mMouseDown Then
		    Return
		  End If
		  
		  If Self.mHoldTimer <> Nil Then
		    RemoveHandler mHoldTimer.Action, AddressOf HoldTimerAction
		    Self.mHoldTimer.RunMode = Timer.RunModes.Off
		    Self.mHoldTimer = Nil
		  End If
		  
		  Self.mMouseDown = False
		  Self.mMouseDownPoint = Nil
		  Var CellIndex As Integer = Self.CellIndexForPoint(New Xojo.Point(X,Y))
		  If Self.mMouseDownIndex = CellIndex Then
		    Self.Value = CellIndex
		  End If
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  Self.AddCells("Home")
		  RaiseEvent Open
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(G As Graphics, Areas() As Xojo.Rect, Highlighted As Boolean)
		  #pragma Unused Areas
		  #pragma Unused Highlighted
		  
		  G.DrawingColor = Self.BackgroundColor
		  G.FillRectangle(0, 0, G.Width, G.Height)
		  
		  Var BorderTopSize, BorderLeftSize, BorderBottomSize, BorderRightSize As Integer
		  If (Self.BorderPosition And Self.BorderTop) = Self.BorderTop Then
		    BorderTopSize = 1
		  End If
		  If (Self.BorderPosition And Self.BorderBottom) = Self.BorderBottom Then
		    BorderBottomSize = 1
		  End If
		  If (Self.BorderPosition And Self.BorderLeft) = Self.BorderLeft Then
		    BorderLeftSize = 1
		  End If
		  If (Self.BorderPosition And Self.BorderRight) = Self.BorderRight Then
		    BorderRightSize = 1
		  End If
		  
		  G.DrawingColor = Self.BorderColor
		  G.DrawRectangle(-1 + BorderLeftSize, -1 + BorderTopSize, (G.Width + 2) - (BorderLeftSize + BorderRightSize), (G.Height + 2) - (BorderTopSize + BorderBottomSize))
		  
		  Var ContentRect As New Xojo.Rect(BorderLeftSize, BorderTopSize, G.Width - (BorderLeftSize + BorderRightSize), G.Height - (BorderTopSize + BorderBottomSize))
		  
		  If Self.mCells.LastIndex > -1 Then
		    Var Rects() As Xojo.Rect
		    
		    Var CellVerticalPadding As Double = 4
		    Var CellHeight As Double = Min(Self.IconHeight + (CellVerticalPadding * 2), ContentRect.Height)
		    Var CellHorizontalPadding As Double = CellHeight / 3
		    
		    Var NextLeft As Double = ContentRect.Left + Self.SeparatorWidth
		    Rects.ResizeTo(Self.mCells.LastIndex)
		    For Idx As Integer = 0 To Self.mCells.LastIndex
		      Var CellWidth As Integer = Ceiling(G.TextWidth(Self.mCells(Idx))) + (CellHorizontalPadding * 2)
		      If Self.mCellIcons(Idx) <> Nil Then
		        If Self.mCells(Idx) <> "" Then
		          CellWidth = CellWidth + Self.IconWidth + CellVerticalPadding
		        Else
		          CellWidth = CellWidth + Self.IconWidth
		        End If
		      End If
		      CellWidth = Max(CellWidth, (CellHorizontalPadding * 2) + Self.IconWidth)
		      Rects(Idx) = New Xojo.Rect(NextLeft, ContentRect.Top, CellWidth, ContentRect.Height)
		      NextLeft = NextLeft + CellWidth + Self.SeparatorWidth
		    Next
		    Var DesiredWidth As Integer = Rects(Rects.LastIndex).Right
		    
		    Var AbsoluteMinimum As Integer = (Self.CellCount * (Self.IconWidth + (CellHorizontalPadding * 2) + Self.SeparatorWidth)) + Self.SeparatorWidth
		    If ContentRect.Width <= AbsoluteMinimum Then
		      // Collapse Everything
		      NextLeft = ContentRect.Left + Self.SeparatorWidth
		      For Idx As Integer = 0 To Rects.LastIndex
		        Rects(Idx).Left = NextLeft
		        Rects(Idx).Width = Self.IconWidth + (CellHorizontalPadding * 2)
		        NextLeft = Rects(Idx).Right + Self.SeparatorWidth
		      Next
		    ElseIf ContentRect.Width <= DesiredWidth Then
		      // Dynamic Scaling
		      Var Groups() As Collection
		      If Self.mCells.LastIndex > 2 Then
		        Var Inner As New Collection
		        For Idx As Integer = 1 To Self.mCells.LastIndex - 2
		          Inner.Add(Idx)
		        Next
		        Groups.Add(Inner)
		      End If
		      Var RootGroup As New Collection
		      RootGroup.Add(0)
		      Groups.Add(RootGroup)
		      If Self.mCells.LastIndex > 0 Then
		        Var Group As New Collection
		        Group.Add(Self.mCells.LastIndex - 1)
		        Groups.Add(Group)
		      End If
		      If Self.mCells.LastIndex > 1 Then
		        Var Group As New Collection
		        Group.Add(Self.mCells.LastIndex)
		        Groups.Add(Group)
		      End If
		      Do
		        For Each Group As Collection In Groups
		          Var Count As Integer = Group.Count
		          Var GroupWasSized As Boolean = False
		          For Idx As Integer = 1 To Count
		            Var Index As Integer = Group.Item(Idx)
		            Var MinWidth As Integer = Self.IconWidth + (CellHorizontalPadding * 2)
		            If Rects(Index).Width > MinWidth Then
		              Rects(Index).Width = Rects(Index).Width - 1
		              DesiredWidth = DesiredWidth - 1
		              GroupWasSized = True
		              If DesiredWidth <= ContentRect.Width Then
		                Exit Do
		              End If
		            End If
		          Next
		          If DesiredWidth > ContentRect.Width And GroupWasSized Then
		            Continue Do
		          End If
		        Next
		      Loop
		      NextLeft = ContentRect.Left + Self.SeparatorWidth
		      For Idx As Integer = 0 To Rects.LastIndex
		        Rects(Idx).Left = NextLeft
		        NextLeft = Rects(Idx).Right + Self.SeparatorWidth
		      Next
		    Else
		      // Everything Fits Nicely
		    End If
		    
		    Self.mCellRects = Rects
		  Else
		    Self.mCellRects.ResizeTo(-1)
		  End If
		  
		  For Idx As Integer = 0 To Self.mCells.LastIndex
		    Self.DrawCell(G, Idx, Idx = Self.mValue, Self.mMouseDown And Self.mMouseDownIndex = Idx)
		  Next
		  G.DrawingColor = Self.mBorderColor
		  For Idx As Integer = 0 To Self.mCells.LastIndex - 1
		    Var Rect As Xojo.Rect = Self.mCellRects(Idx)
		    Var SeparatorRect As New Xojo.Rect(Rect.Right, Rect.Top, Self.SeparatorWidth, Rect.Height)
		    Var CenterX As Double = SeparatorRect.HorizontalCenter
		    Var CenterY As Double = SeparatorRect.VerticalCenter
		    
		    Var Arrow As New GraphicsPath
		    Arrow.MoveToPoint(ArtisanKit.NearestMultiple(CenterX + 2, G.ScaleX), ArtisanKit.NearestMultiple(CenterY, G.ScaleY))
		    Arrow.AddLineToPoint(ArtisanKit.NearestMultiple(CenterX - 1, G.ScaleX), ArtisanKit.NearestMultiple(CenterY - 3, G.ScaleY))
		    Arrow.AddLineToPoint(ArtisanKit.NearestMultiple(CenterX - 2, G.ScaleX), ArtisanKit.NearestMultiple(CenterY - 2, G.ScaleY))
		    Arrow.AddLineToPoint(ArtisanKit.NearestMultiple(CenterX, G.ScaleX), ArtisanKit.NearestMultiple(CenterY, G.ScaleY))
		    Arrow.AddLineToPoint(ArtisanKit.NearestMultiple(CenterX - 2, G.ScaleX), ArtisanKit.NearestMultiple(CenterY + 2, G.ScaleY))
		    Arrow.AddLineToPoint(ArtisanKit.NearestMultiple(CenterX - 1, G.ScaleX), ArtisanKit.NearestMultiple(CenterY + 3, G.ScaleY))
		    Arrow.AddLineToPoint(ArtisanKit.NearestMultiple(CenterX + 2, G.ScaleX), ArtisanKit.NearestMultiple(CenterY, G.ScaleY))
		    
		    G.FillPath(Arrow)
		  Next
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddCells(ParamArray Cells() As String)
		  For Each Cell As String In Cells
		    Self.mCells.Add(Cell)
		    Self.mCellIcons.Add(Nil)
		    Self.mCellIconTypes.Add(IconTypeFullColor)
		  Next
		  Self.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Cell(Index As Integer) As String
		  Return Self.mCells(Index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cell(Index As Integer, Assigns NewValue As String)
		  Self.mCells(Index) = NewValue
		  Self.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellIcon(Index As Integer) As Picture
		  Return Self.mCellIcons(Index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellIcon(Index As Integer, Assigns NewValue As Picture)
		  Self.mCellIcons(Index) = NewValue
		  Self.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellIconType(Index As Integer) As Integer
		  Return Self.mCellIconTypes(Index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellIconType(Index As Integer, Assigns NewValue As Integer)
		  Self.mCellIconTypes(Index) = NewValue
		  Self.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CellIndexForPoint(Point As Xojo.Point) As Integer
		  For I As Integer = 0 To mCellRects.LastIndex
		    If mCellRects(I).Contains(Point) Then
		      Return I
		    End If
		  Next
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Setup default colors
		  
		  Self.mBorderPosition = Self.BorderBottom
		  Self.mBackgroundColor = New ColorGroup(&c000000FF)
		  
		  #if TargetMacOS
		    Self.mBorderColor = New ColorGroup("separatorColor")
		    Self.mTextColor = New ColorGroup("labelColor")
		    Self.mActiveBackgroundColor = New ColorGroup("selectedContentBackgroundColor")
		    Self.mActiveTextColor = New ColorGroup("alternateSelectedControlTextColor")
		  #else
		    Self.mBorderColor = New ColorGroup(&c000000E6)
		    Self.mTextColor = New ColorGroup(&c00000027)
		    Self.mActiveBackgroundColor = New ColorGroup(&c0749D900)
		    Self.mActiveTextColor = New ColorGroup(&cFFFEFE00)
		  #endif
		  
		  Super.Constructor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteAllCells()
		  Self.CellCount = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawCell(G As Graphics, Index As Integer, Active As Boolean, Pressed As Boolean)
		  Var CellRect As Xojo.Rect = Self.mCellRects(Index)
		  G = G.Clip(CellRect.Left, CellRect.Top, CellRect.Width, CellRect.Height)
		  
		  Var CellVerticalPadding As Double = 4
		  Var CellHeight As Double = Min(Self.IconHeight + (CellVerticalPadding * 2), G.Height)
		  Var CellHorizontalPadding As Double = CellHeight / 3
		  Var CellTop As Double = ArtisanKit.NearestMultiple((G.Height - CellHeight) / 2, G.ScaleY)
		  
		  Const PressedOpacity = 0.25
		  
		  If Active And Pressed Then
		    G.DrawingColor = ArtisanKit.BlendColors(Self.mActiveBackgroundColor, &c000000, PressedOpacity)
		    G.FillRoundRectangle(0, CellTop, G.Width, CellHeight, CellHeight, CellHeight)
		  ElseIf Pressed Then
		    G.DrawingColor = Color.RGB(0, 0, 0, 255 - (255 * PressedOpacity))
		    G.FillRoundRectangle(0, CellTop, G.Width, CellHeight, CellHeight, CellHeight)
		  ElseIf Active Then
		    G.DrawingColor = Self.mActiveBackgroundColor
		    G.FillRoundRectangle(0, CellTop, G.Width, CellHeight, CellHeight, CellHeight)
		  End If
		  
		  Var TextColor As Color
		  If Active Then
		    TextColor = Self.ActiveTextColor
		  Else
		    TextColor = Self.TextColor
		  End If
		  If Pressed Then
		    TextColor = ArtisanKit.BlendColors(TextColor, &c000000, PressedOpacity)
		  End If
		  
		  Var Icon As Picture = Self.CellIcon(Index)
		  Var HasIcon As Boolean = (Icon Is Nil) = False
		  Var TextBaseline As Double = ArtisanKit.NearestMultiple((G.Height / 2) + (G.CapHeight / 2), G.ScaleY)
		  Var TextLeft As Double = CellHorizontalPadding
		  Var TextWidthLimit As Double = G.Width - (CellHorizontalPadding * 2)
		  If HasIcon Then
		    TextLeft = TextLeft + CellVerticalPadding + Self.IconWidth
		    TextWidthLimit = TextWidthLimit - (CellVerticalPadding + Self.IconWidth)
		  End If
		  
		  Var IconLeft As Double
		  Var Caption As String = Self.Cell(Index)
		  Var IconOnly As Boolean = TextWidthLimit <= 20
		  If IconOnly And HasIcon Then
		    IconLeft = (G.Width - Self.IconWidth) / 2
		  ElseIf Caption.IsEmpty = False Then
		    If IconOnly Then
		      Caption = Caption.Left(1)
		      TextLeft = (G.Width - G.TextWidth(Caption)) / 2
		    End If
		    G.DrawingColor = TextColor
		    G.DrawText(Caption, ArtisanKit.NearestMultiple(TextLeft, G.ScaleX), ArtisanKit.NearestMultiple(TextBaseline, G.ScaleY), TextWidthLimit, True)
		    IconLeft = CellHorizontalPadding
		  End If
		  
		  If (Icon Is Nil) = False Then
		    Var IconType As Integer = Self.CellIconType(Index)
		    Select Case IconType
		    Case Self.IconTypeFullColor
		      G.DrawPicture(Icon, ArtisanKit.NearestMultiple(IconLeft, G.ScaleX), ArtisanKit.NearestMultiple((G.Height - Self.IconWidth) / 2, G.ScaleY), Self.IconWidth, Self.IconWidth, 0, 0, Icon.Width, Icon.Height)
		    Case Self.IconTypeMask
		      Var Mask As Picture = G.NewPicture(Icon.Width, Icon.Height)
		      Mask.Graphics.DrawingColor = &cFFFFFF
		      Mask.Graphics.FillRectangle(0, 0, Mask.Width, Mask.Height)
		      Mask.Graphics.DrawPicture(Icon, 0, 0)
		      
		      Var Template As Picture = G.NewPicture(Icon.Width, Icon.Height)
		      Template.Graphics.DrawingColor = TextColor
		      Template.Graphics.FillRectangle(0, 0, Template.Width, Template.Height)
		      Template.ApplyMask(Mask)
		      G.DrawPicture(Template, ArtisanKit.NearestMultiple(IconLeft, G.ScaleX), ArtisanKit.NearestMultiple((G.Height - Self.IconWidth) / 2, G.ScaleY), Self.IconWidth, Self.IconWidth, 0, 0, Template.Width, Template.Height)
		    Case Self.IconTypeAlpha
		      Var Mask As Picture = G.NewPicture(Icon.Width, Icon.Height)
		      Mask.Graphics.DrawPicture(Icon, 0, 0)
		      
		      Var Fill As Picture = G.NewPicture(Icon.Width, Icon.Height)
		      Fill.Graphics.DrawingColor = TextColor
		      Fill.Graphics.FillRectangle(0, 0, Fill.Width, Fill.Height)
		      Fill.ApplyMask(Mask.CopyMask)
		      G.DrawPicture(Fill, ArtisanKit.NearestMultiple(IconLeft, G.ScaleX), ArtisanKit.NearestMultiple((G.Height - Self.IconWidth) / 2, G.ScaleY), Self.IconWidth, Self.IconWidth, 0, 0, Fill.Width, Fill.Height)
		    End Select
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HoldTimerAction(Sender As Timer)
		  #pragma Unused Sender
		  
		  If CellHold(Self.mMouseDownIndex) Then
		    Self.mMouseDown = False
		    Self.mMouseDownPoint = Nil
		    Self.Invalidate
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertCells(Index As Integer, ParamArray Cells() As String)
		  For Each Cell As String In Cells
		    Self.mCells.AddAt(Index,Cell)
		    Self.mCellIcons.AddAt(Index,Nil)
		    Self.mCellIconTypes.AddAt(Index,IconTypeFullColor)
		    If Self.mValue >= Index Then
		      Self.mValue = Self.mValue + 1
		    End If
		    Index = Index + 1
		  Next
		  Self.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveCells(Index As Integer, Count As Integer = 1)
		  Count = Min(Count,Self.mCells.LastIndex - (Index - 1))
		  For I As Integer = 1 To Count
		    Self.mCells.RemoveAt(Index)
		    Self.mCellIcons.RemoveAt(Index)
		    Self.mCellIconTypes.RemoveAt(Index)
		    If Self.mValue >= Index Then
		      Self.mValue = Self.mValue - 1
		    End If
		  Next
		  Self.Invalidate
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CellHold(CellIndex As Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Change()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Paint(G As Graphics, ScalingFactor As Double)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mActiveBackgroundColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mActiveBackgroundColor <> Value Then
			    Self.mActiveBackgroundColor = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		ActiveBackgroundColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mActiveTextColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mActiveTextColor <> Value Then
			    Self.mActiveTextColor = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		ActiveTextColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBackgroundColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mBackgroundColor <> Value Then
			    Self.mBackgroundColor = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		BackgroundColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBorderColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mBorderColor <> Value Then
			    Self.mBorderColor = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		BorderColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBorderPosition
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value = Value And (Self.BorderTop Or Self.BorderBottom Or Self.BorderLeft Or Self.BorderRight)
			  
			  If Self.mBorderPosition <> Value Then
			    Self.mBorderPosition = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		BorderPosition As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mCells.Count
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mCells.ResizeTo(Value - 1)
			  Self.mCellIcons.ResizeTo(Value - 1)
			  Self.mCellIconTypes.ResizeTo(Value - 1)
			  Self.Invalidate
			End Set
		#tag EndSetter
		CellCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mActiveBackgroundColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mActiveTextColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBackgroundColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBorderColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBorderPosition As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCellIcons() As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCellIconTypes() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCellRects() As Xojo.Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCells() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHoldTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMouseDown As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMouseDownIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMouseDownPoint As Xojo.Point
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTextColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mValue As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mTextColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mTextColor <> Value Then
			    Self.mTextColor = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		TextColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mValue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value = Max(Min(Value,Self.CellCount - 1),0)
			  If Value <> Self.mValue Then
			    Self.mValue = Value
			    RaiseEvent Change()
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		Value As Integer
	#tag EndComputedProperty


	#tag Constant, Name = BorderBottom, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BorderLeft, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BorderRight, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BorderTop, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IconHeight, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IconTypeAlpha, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IconTypeFullColor, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IconTypeMask, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IconTypeTemplate, Type = Double, Dynamic = False, Default = \"1", Scope = Public, Attributes = \"Deprecated \x3D "IconTypeMask""
	#tag EndConstant

	#tag Constant, Name = IconWidth, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SeparatorWidth, Type = Double, Dynamic = False, Default = \"12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Version, Type = String, Dynamic = False, Default = \"2.0", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=false
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasFocus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group=""
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NeedsFullKeyboardAccessForFocus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollSpeed"
			Visible=false
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Animated"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c9e9e9e"
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderPosition"
			Visible=true
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - None"
				"1 - Bottom"
				"2 - Top"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="CellCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ActiveBackgroundColor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ActiveTextColor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextColor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
