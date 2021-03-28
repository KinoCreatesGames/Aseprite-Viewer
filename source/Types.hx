import haxe.extern.EitherType;

// Depot Information
typedef DepotFile = {
	var sheets:Array<DepotSheet>;
}

typedef DepotSheet = {
	var name:String;
	var description:String;
	var displayColumn:String;
	var guid:String;
	var columns:Array<ColumnInfo>;
	var lines:Array<LineInfo>;
	var hidden:Bool;
	var configurable:{
		var name:String;
		var description:String;
		var displayColumn:String;
	}
	var ?parentSheetGUID:String;
	var ?columnGUID:String;
}

typedef ColumnInfo = {
	var typeStr:TypeString;
	var guid:String;
	var name:String;
	var description:String;
	var defaultValue:String;
	var sheet:String;
	var iconName:String;
	var configurable:ConfigInfo;
}

typedef ConfigInfo = {
	var name:String;
	var description:String;
	var defaultValue:EitherType<String, Array<Dynamic>>;
}

typedef LineInfo = {
	var guid:String;
	var id:String;
}

enum abstract TypeString(String) from String to String {
	public var TEXT = 'text';
	public var LONGTEXT = 'longtext';
	public var BOOL = 'bool';
	public var INT = 'int';
	public var FLOAT = 'float';
	public var IMAGE = 'image';
	public var LIST = 'list';
	public var ENUM = 'enum';
}