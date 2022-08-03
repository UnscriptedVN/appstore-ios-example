# Candella AppDB API Example

This repository contains an example project using the Candella AppDB
API to fetch Candella projects and store them in a Core Data database.

## Getting Started

**Required Tools**
- Xcode 13 or later
- macOS 12.4 Monterey or later

Clone the repository from GitHub using `git clone` or `gh repo clone` and
open the Xcode project file in the **My AppDB** folder. Run **Product > Run**
to run the project in the Simulator.

## Known Limitations

- The table view in the Cart tab will not update correctly with
  `model.bundUpdating`. The workaround of calling `self.table.reloadData`
  manually has been added to address this.

## License

This example is licensed under the Mozilla Public License, v2.0. You can
read your rights in the LICENSE file provided.
