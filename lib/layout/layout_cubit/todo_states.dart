abstract class TodoLayoutStates {}

class TodoLayoutInitialState extends TodoLayoutStates {}

class TodoLayoutChangeIndexState extends TodoLayoutStates {}

class TodoLayoutChangeDateSuccessState extends TodoLayoutStates {}

class TodoLayoutChangeDateErrorState extends TodoLayoutStates {}

class TodoLayoutChangeColorIndexState extends TodoLayoutStates {}

class TodoLayoutChangeIconState extends TodoLayoutStates {}

class TodoLayoutCreateDataBaseState extends TodoLayoutStates {}

class TodoLayoutInsertDataBaseSuccessState extends TodoLayoutStates {}

class TodoLayoutInsertDataBaseErrorState extends TodoLayoutStates {}

class TodoLayoutGetDataBaseLoadingState extends TodoLayoutStates {}

class TodoLayoutGetDataBaseSuccessState extends TodoLayoutStates {}

class TodoLayoutGetDataBaseErrorState extends TodoLayoutStates {}

class TodoLayoutUpdateDataBaseSuccessState extends TodoLayoutStates {}

class TodoLayoutUpdateDataBaseErrorState extends TodoLayoutStates {}

class TodoLayoutDeleteDataBaseSuccessState extends TodoLayoutStates {}

class TodoLayoutDeleteDataBaseErrorState extends TodoLayoutStates {}
