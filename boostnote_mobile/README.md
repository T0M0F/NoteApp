# boostnote_mobile

## Architecture

Presentation Layer:
- Pages - view
- Widgets (common widgets) - view
- Controller/ModelView/Presenter/BLoc?????? - communicates with view and business layer

Business Layer:
- Services/Usecases/Interactors - contains business logic
- Domain Model/Entity
- Repository Interface - linking point between business and data layer

Data Layer:
- Model - extends Business Model and adds additional data layer functionality like toCson() or fromCson()
- Repository Implemetation - uses some kind of Datasource provided by the framework for storing data, implements Repository Interface
