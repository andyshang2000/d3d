package zzsdk.editor.utils
{
	import flash.filesystem.File;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;

	public class BindingUtil
	{
		private static var bindingList:Vector.<Binding> = new Vector.<Binding>;
		private static var quickLookTable:Object = {};
		private static var filesNeedToOverwrite:Array = [];
		
		setFactory(new BindingFactory);

		public static function setFactory(factory:BindingFactory):void
		{
			//其实啥也不用做╮(╯_╰)╭
		}

		public static function bind(model:Object, field:String, comp:*, compField:String = null, setter:* = null, getter:* = null):Binding
		{
			compField ||= field;
			var binding:Binding = BindingFactory.create(model, field, comp, compField, setter, getter);
			if (filesNeedToOverwrite.indexOf(model) == -1)
			{
				filesNeedToOverwrite.push(model)
			}
			bindingList.push(binding);
			return binding;
		}

		public static function updateView():void
		{
			for (var i:int = 0; i < bindingList.length; i++)
			{
				bindingList[i].updateView();
			}
		}

		public static function updateModel():void
		{
			for (var i:int = 0; i < bindingList.length; i++)
			{
				bindingList[i].updateModel();
			}
		}

		public static function registerAlias(obj:Object):void
		{
			var qname:String = getQualifiedClassName(obj);
			var shortName:String = qname.substr(qname.lastIndexOf(":") + 1);
			quickLookTable[shortName] = qname;
		}

		public static function writeBack():void
		{
			updateModel();
			for each (var model:Object in filesNeedToOverwrite)
			{
				writeBackFile(model);
			}
		}

		private static function writeBackFile(model:Object):void
		{
			var className:String = getQualifiedClassName(model)
			var path:String = className;
			path = path.split("::").join("/");
			path = path.split(".").join("/");
			path += ".as";
			var file:File = new File(Client.resolve("bin/src/" + path))
			var str:String = FileUtil.readFile(file, "text", "utf-8");
			var type:XML = describeType(model);

			for each (var v:XML in type.variable)
			{
				var reg:RegExp = new RegExp(StringUtil.substitute("public static var {0}:String = \".*\"", v.@name));
				var nameline:String = StringUtil.substitute("public static var {0}:String = \"{1}\"", v.@name, model[v.@name]);
				str = str.replace(reg, nameline);
			}
			FileUtil.save(str, file.nativePath);
		}

		public static function getModel(bindTerm:String):Object
		{
			var clazz:String = bindTerm.substr(0, bindTerm.indexOf("."));
			return getDefinitionByName(quickLookTable[clazz]);
		}

		public static function getFieldName(bindTerm:String):String
		{
			return bindTerm.substr(bindTerm.indexOf(".") + 1);
		}

		{
			registerAlias(GameInfo)
		}
	}
}
