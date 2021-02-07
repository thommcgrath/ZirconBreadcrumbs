# ZirconBreadcrumbs
A breadcrumbs control (also known as a path control) is a great way to give users a sense of place in a hierarchical navigation.

- Uses system colors, including dark mode, out of the box. Colors are fully customizable.
- Fully vector, supports all resolutions, and does not require any images.
- Cells support full color and template icons.
- Cells support click-and-hold, useful for display additional options.
- Fully self-contained, no images to include in your project. Only requires the [Artisan Kit 1.2.2](https://github.com/thommcgrath/ArtisanKit) module, which is included.
- Requires Xojo 2020r2 or later.

### Compatibility Notice

ZirconBreadcrumbs 2.0 is not fully backwards compatible with previous versions of the control. Some projects will need to update code. The changes required are minimal, and will trigger compile errors. There are no silent compatibility issues.

ZirconBreadcrumbs really does require Xojo 2020r2. It makes use of the ColorGroup class, which was added to desktop projects in 2020r2. The ColorGroup class adds support for dark mode and system colors that is just too convenient to pass up.

## Building Documentation

Documentation is powered by [MkDocs](http://www.mkdocs.org/). Simply `cd` into the Documentation directory and `mkdocs build` after installing MkDocs. Release builds will contain compiled documentation as well as hosted documentation.
