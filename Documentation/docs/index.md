# ZirconBreadcrumbs

A breadcrumbs control is used to show hierarchy. It pairs nicely with file browsers and other nested content.

## Requirements

This control requires Xojo 2020r2 and [Artisan Kit 1.2.2](https://github.com/thommcgrath/ArtisanKit/releases/). Only desktop projects are supported.

## Installation

Open the binary project and copy both the ZirconBreadcrumbs class and ArtisanKit module into your project. If you already use Artisan Kit and encounter compile errors with the control, your ArtisanKit module needs to be updated to the included version.

## Getting Started

Drag a ZirconBreadcrumbs control onto a window, just like any other control. The control can support any vertical height, but the default height of 29 pixels usually works best.

## Events

<pre id="event.cellhold"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Event</span> CellHold (CellIndex <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>) <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Boolean</span></span></pre>
The user has held their mouse down on an item. This could be used to show a menu allowing the user to change that level of hierarchy.

<pre id="event.change"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Event</span> Change ()</span></pre>
Works exactly like the `Change` event from a ListBox. It fires when a cell has been clicked.

## Properties

<pre id="property.activebackgroundcolor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ActiveBackgroundColor <span style="color: #0000ff;">As</span> ColorGroup</span></pre>
The background color used for the currently selected cell.

<pre id="property.activetextcolor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ActiveTextColor <span style="color: #0000ff;">As</span> ColorGroup</span></pre>
The text color used for the currently selected cell.

<pre id="property.backgroundcolor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">BackgroundColor <span style="color: #0000ff;">As</span> ColorGroup</span></pre>
The color used behind the entire control, including behind the border. The background color will show through the border if the border has transparency.

<pre id="property.bordercolor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">BorderColor <span style="color: #0000ff;">As</span> ColorGroup</span></pre>
The color used for the borders and the small arrows between each cell.

<pre id="property.borderposition"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">BorderPosition <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span></span></pre>
Describes the edges the control should draw a border. Use the `BorderNone` constant for no border. The `BorderTop`, `BorderBottom`, `BorderLeft`, and `BorderRight` constants can be `OR`'d together to achieve borders on multiple edges. For example, to get a top and bottom border, use: <code><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">BorderPosition = BorderTop <span style="color: #0000ff;">Or</span> BorderBottom</span></code>.

<pre id="property.cellcount"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">CellCount <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span></span></pre>
The number of cells. You can set this property and the control will add empty cells or remove cells as necessary.

<pre id="property.textcolor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">TextColor <span style="color: #0000ff;">As</span> ColorGroup</span></pre>
The color used to draw text for cells that are not selected.

<pre id="property.value"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Value <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span></span></pre>
The currently selected cell. Zero-based index like most lists in Xojo.

## Methods

<pre id="method.addcells"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Sub</span> AddCells(<span style="color: #0000ff;">ParamArray</span> Cells() <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">String</span>)</span></pre>
Adds the cells to the end of the hierarchy.

<pre id="method.cell"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Function</span> Cell (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>) <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">String</span>
<span style="color: #0000ff;">Sub</span> Cell (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>, <span style="color: #0000ff;">Assigns</span> NewValue <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">String</span>)</span></pre>
Used to get or set the cell caption at the zero-based index.

<pre id="method.cellicon"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Function</span> CellIcon (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>) <span style="color: #0000ff;">As</span> Picture
<span style="color: #0000ff;">Sub</span> CellIcon (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>, <span style="color: #0000ff;">Assigns</span> NewValue <span style="color: #0000ff;">As</span> Picture)</span></pre>
Used to get or set the cell icon at the zero-based index. It is ok to set this to `Nil` to remove an icon.

<pre id="method.cellicontype"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Function</span> CellIconType (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>) <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>
<span style="color: #0000ff;">Sub</span> CellIconType (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>, <span style="color: #0000ff;">Assigns</span> NewValue <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>)</span></pre>
Used to get or set the type of icon to draw on the cell. Use the following constants:

- `IconTypeAlpha`: The icon will be drawn to match the text color according to the icon's alpha channel.
- `IconTypeMask`: The icon will be drawn to match the text color by treating the icon as a black and white mask. Works best with icons that do not have alpha channels.
- `IconTypeFullColor`: The icon will be drawn as-is.

<pre id="method.deleteallcells"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Sub</span> DeleteAllCells ()</span></pre>
Deletes all the cells.

<pre id="method.insertcells"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Sub</span> InsertCells (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>, <span style="color: #0000ff;">ParamArray</span> Cells() <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">String</span>)</span></pre>
Adds cells starting at the given zero-based index.

<pre id="method.removecells"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Sub</span> RemoveCells (Index <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>, Count <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span> = <span style="color: #336698;">1</span>)</span></pre>
Removes one or more cells starting at the given index.