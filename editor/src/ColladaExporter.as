package
{
	import flash.display.Sprite;

	public class ColladaExporter extends Sprite
	{
		public function ColladaExporter()
		{
			super();
			ColladaLoader
		}
	}
}
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import __AS3__.vec.Vector;

import flare.basic.Scene3D;
import flare.core.Camera3D;
import flare.core.Frame3D;
import flare.core.Light3D;
import flare.core.Mesh3D;
import flare.core.Pivot3D;
import flare.core.Surface3D;
import flare.core.Texture3D;
import flare.flsl.FLSLFilter;
import flare.materials.Shader3D;
import flare.materials.filters.ColorFilter;
import flare.materials.filters.SpecularMapFilter;
import flare.materials.filters.TextureMapFilter;
import flare.modifiers.Modifier;
import flare.modifiers.SkinModifier;
import flare.system.Device3D;
import flare.system.ILibraryExternalItem;
import flare.system.Library3D;
import flare.utils.Mesh3DUtils;
import flare.utils.Surface3DUtils;
import flare.utils.Vector3DUtils;

class ColladaLoader extends Pivot3D implements ILibraryExternalItem
{

	private var _loader:URLLoader;
	private var _parsed:Boolean;
	private var _axis:int = 0
	private var _file:String;
	private var _library:Library3D;
	private var _loaded:Boolean;
	private var _flipNormals:Boolean;
	private var _cullFace:String;
	private var _nullMaterials:Dictionary;
	private var _folder:String = ""
	private var _texturesFolder:String;
	private var _loadCount:int;
	private var _request;
	private var _sceneContext:Scene3D;
	private var _parent:Pivot3D;
	private var _dae:XML;
	private var _daeSid:Array;
	private var _daeNodes:Dictionary;
	private var _daeGeometry:Dictionary;
	private var _daeAnimation:Dictionary;
	private var _daeIndices:Dictionary;
	private var _daeControllers:Dictionary;
	private var _daeImages:Dictionary;
	private var _daeFilters:Dictionary;
	private var _daeMaterials:Dictionary;
	private var _daeSurfaces:Dictionary;
	private var _daeSkinRoots:Dictionary;
	private var _daeUpdateControllers:Array;
	private var _daeUpdateSkeletons:Array;
	private var _daeCameras:Dictionary;
	private var _daeLights:Dictionary;
	private var _fuckingInstanceNodes:Array;
	private var _skinRoot:Pivot3D;

	public static var requestTexture:Function;

	public function ColladaLoader(request, parent:Pivot3D = null, sceneContext:Scene3D = null, //
		texturesFolder:String = null, flipNormals:Boolean = false, cullFace:String = "back")
	{
		var index:int;
		this._nullMaterials = new Dictionary(true);
		this._daeSid = [];
		this._daeNodes = new Dictionary(true);
		this._daeGeometry = new Dictionary(true);
		this._daeAnimation = new Dictionary(true);
		this._daeIndices = new Dictionary(true);
		this._daeControllers = new Dictionary(true);
		this._daeImages = new Dictionary(true);
		this._daeFilters = new Dictionary(true);
		this._daeMaterials = new Dictionary(true);
		this._daeSurfaces = new Dictionary(true);
		this._daeSkinRoots = new Dictionary(true);
		this._daeUpdateControllers = [];
		this._daeUpdateSkeletons = [];
		this._daeCameras = new Dictionary(true);
		this._daeLights = new Dictionary(true);
		this._fuckingInstanceNodes = [];
		this._skinRoot = new Pivot3D("Skin Root");
		super();
		this._parent = ((parent) || (this));
		this._texturesFolder = texturesFolder;
		this._flipNormals = flipNormals;
		this._cullFace = cullFace;
		this._request = request;
		this._sceneContext = sceneContext;
		if ((this._request is XML))
		{
			this._dae = this._request;
			if (texturesFolder)
			{
				this._folder = this._texturesFolder;
			}
			else
			{
				this._folder = "";
			}
			;
		}
		else
		{
			if ((this._request is String))
			{
				request = request.replace(/\\/g, "/");
				index = request.lastIndexOf("/");
				if (texturesFolder)
				{
					this._folder = this._texturesFolder;
				}
				else
				{
					if (index != -1)
					{
						this._folder = request.substr(0, (index + 1));
					}
					;
				}
				;
				this._file = request;
				name = request.substr((request.lastIndexOf("/") + 1));
			}
			;
		}
		;
	}

	public function get bytesTotal():uint
	{
		return (((this._loader) ? this._loader.bytesTotal : 0 + (this._library) ? this._library.bytesTotal : 0));
	}

	public function get bytesLoaded():uint
	{
		return (((this._loader) ? this._loader.bytesLoaded : 0 + (this._library) ? this._library.bytesLoaded : 0));
	}

	public function load():void
	{
		if (this._dae)
		{
			this.start();
			return;
		}
		;
		if (this._loader)
		{
			return;
		}
		;
		this._loader = new URLLoader();
		this._loader.dataFormat = URLLoaderDataFormat.TEXT;
		this._loader.addEventListener("progress", dispatchEvent, false, 0, true);
		this._loader.addEventListener("complete", this.completeEvent, false, 0, true);
		this._loader.load(new URLRequest(this._file));
	}

	public function close():void
	{
		if (this._loader)
		{
			this._loader.close();
		}
		;
	}

	public function get loaded():Boolean
	{
		return (this._loaded);
	}

	private function completeEvent(e:Event):void
	{
		var str:String;
		var l:int;
		var e = e;
		e.stopImmediatePropagation();
		str = this._loader.data;
		this._dae = new XML(str);
		this.start();
	}

	private function start():void
	{
		var node:XML;
		var z:int;
		var iNode:*;
		if (this._parsed)
		{
			return;
		}
		;
		this._parsed = true;
		if (this._dae.asset.up_axis.text() == "Y_UP")
		{
			this._axis = 1;
		}
		;
		var instanceVisualSceneUrl:String = this._dae.scene.instance_visual_scene.@url.substr(1);
		var visualSceneNodes:XMLList = this._dae.library_visual_scenes.visual_scene.(@id == instanceVisualSceneUrl).node;
		for each (node in this._dae.library_cameras.camera)
		{
			this.getCamera(node);
		}
		;
		for each (node in this._dae.library_lights.light)
		{
			this.getLight(node);
		}
		;
		for each (node in this._dae.library_images.image)
		{
			this.getImage(node);
		}
		;
		for each (node in this._dae.library_materials.material)
		{
			this.getEffect(node);
		}
		;
		for each (node in this._dae.library_geometries.geometry)
		{
			this.getGeometry(node);
		}
		;
		for each (node in this._dae.library_controllers.controller)
		{
			this.getController(node);
		}
		;
		z = (this._dae.library_nodes.node.length() - 1);
		while (z >= 0)
		{
			this.getNode(this._dae.library_nodes.node[z]);
			z = (z - 1);
		}
		;
		for each (node in visualSceneNodes)
		{
			this._parent.addChild(this.getNode(node));
		}
		;
		for each (iNode in this._fuckingInstanceNodes)
		{
			iNode.pivot.addChild(this._daeNodes[iNode.id].clone());
		}
		;
		for each (node in this._dae.library_animations.animation)
		{
			this.getAnimation(node);
		}
		;
		for each (node in this._daeUpdateControllers)
		{
			this.updateController(node);
		}
		;
		this.frameSpeed = frameSpeed;
		if (this._axis == 1)
		{
			rotateX(-90, false, Vector3DUtils.ZERO);
		}
		;
		play();
		if (((!(this._library)) || ((this._loadCount == 0))))
		{
			this._loaded = true;
			dispatchEvent(new Event("complete"));
		}
		;
		this._daeNodes = null;
		this._daeGeometry = null;
		this._daeAnimation = null;
		this._daeIndices = null;
		this._daeControllers = null;
		this._daeImages = null;
		this._daeFilters = null;
		this._daeSurfaces = null;
		this._daeUpdateControllers = null;
		this._daeUpdateSkeletons = null;
		this._daeSkinRoots = null;
		this._daeSid = null;
		this._dae = null;
		this._nullMaterials = null;
	}

	private function optimizeSurfaces(mesh:Mesh3D):void
	{
		var surf:Surface3D;
		for each (surf in mesh.surfaces)
		{
			Surface3DUtils.compress(surf);
		}
		;
	}

	private function getEffect(node:XML):void
	{
		var effect:XMLList;
		var technique:XMLList;
		var material:XML;
		var filters:Array;
		var channel:String;
		var colorComponents:Array;
		var color:int;
		var texture:Texture3D;
		var sampler:XMLList;
		var surface:XMLList;
		var init_from:String;
		var specularTexture:Texture3D;
		var sampler2:XMLList;
		var surface2:XMLList;
		var init_from2:String;
		var node = node;
		effect = this._dae.library_effects.effect.(@id == node.instance_effect.@url.substr(1));
		technique = effect.profile_COMMON.technique;
		if (technique.children().length() > 0)
		{
			material = technique.children()[0];
			filters = [];
			if (material.diffuse != undefined)
			{
				channel = material.diffuse.texture.@texcoord;
				if (material.diffuse.color != undefined)
				{
					colorComponents = material.diffuse.color.split(/\s+/);
					color = this.combineRGB((colorComponents[0] * 0xFF), (colorComponents[1] * 0xFF), (colorComponents[2] * 0xFF));
					filters.push(new ColorFilter(color, Number(colorComponents[3])));
				}
				;
				if (material.diffuse.texture != undefined)
				{
					texture = this._daeImages[material.diffuse.texture[0].@texture.toString()];
				}
				;
				if (!(texture))
				{
					sampler = effect.profile_COMMON.newparam.(@sid == material.diffuse.texture.@texture);
					surface = effect.profile_COMMON.newparam.(@sid == sampler.sampler2D.source.text());
					init_from = surface.surface.init_from.text();
					texture = this._daeImages[init_from];
				}
				;
				if (texture)
				{
					filters.push(new TextureMapFilter(texture, ((channel == "CHANNEL1")) ? 1 : 0));
				}
				;
			}
			;
			if (material.specular != undefined)
			{
				if (material.specular.texture != undefined)
				{
					specularTexture = this._daeImages[material.specular.texture[0].@texture.toString()];
					if (!(specularTexture))
					{
						sampler2 = effect.profile_COMMON.newparam.(@sid == material.specular.texture.@texture);
						surface2 = effect.profile_COMMON.newparam.(@sid == sampler2.sampler2D.source.text());
						init_from2 = surface2.surface.init_from.text();
						specularTexture = this._daeImages[init_from2];
					}
					;
					if (specularTexture)
					{
						filters.push(new SpecularMapFilter(specularTexture, Number(material.shininess.float)));
					}
					;
				}
				else
				{
					if (Number(material.shininess.float) > 0)
					{
					}
					;
				}
				;
			}
			;
			if (material.bump != undefined)
			{
				trace("Bump map!");
			}
			;
			this._daeFilters[node.@id.toString()] = filters;
		}
		;
	}

	private function combineRGB(r:int, g:int, b:int):int
	{
		return ((((r << 16) | (g << 8)) | b));
	}

	private function getImage(node:XML):void
	{
		if (!(this._library))
		{
			this._library = new Library3D(1);
			this._library.addEventListener("progress", this.resourceProgressEvent, false, 0, true);
			this._library.addEventListener("complete", this.resourceCompleteEvent, false, 0, true);
		}
		;
		var file:String = node.init_from.text();
		file = file.replace(/\\/g, "/");
		while (file.charAt(0) == "/")
		{
			file = file.substr(1);
		}
		;
		var folder:String = this._folder;
		while (file.indexOf("../") == 0)
		{
			folder = (folder.substr(0, folder.lastIndexOf("/", (folder.length - 2))) + "/");
			file = file.substr(3);
		}
		;
		if (file.indexOf("file://") == -1)
		{
			file = (folder + file);
		}
		else
		{
			file = (folder + file.substr((file.lastIndexOf("/") + 1)));
		}
//		;
//		if (_slot1.requestTexture != null)
//		{
//			this._daeImages[node.@id.toString()] = _slot1.requestTexture(file);
//			return;
//		}
//		;
		var texture:Texture3D = (this.libraryContext.getItem(file) as Texture3D);
		var ext:String = file.substr(-3).toLowerCase();
		if (((!((ext == "jpg"))) && (!((ext == "png")))))
		{
			trace("Error: Invalid texture format", ext, "in file", file);
			texture = new Texture3D(Device3D.nullBitmapData);
		}
		;
		if (!(texture))
		{
			texture = new Texture3D(file, false);
			if (scene)
			{
				texture.scene = scene;
			}
			;
			this.libraryContext.addItem(file, texture);
			this._library.push(texture);
			this._loadCount++;
		}
		;
		this._daeImages[node.@id.toString()] = texture;
	}

	private function resourceProgressEvent(e:Event):void
	{
		dispatchEvent(e);
	}

	private function resourceCompleteEvent(e:Event):void
	{
		this._loaded = true;
		if (scene)
		{
			upload(scene);
		}
		;
		dispatchEvent(new Event("complete"));
	}

	private function getAnimation(node:XML):void
	{
		var anim:XML;
		var channel:XML;
		var sampler:XMLList;
		var input:XMLList;
		var output:XMLList;
		var values:Array;
		var frames:Vector.<Frame3D>;
		var target:String;
		var node = node;
		for each (anim in node.animation)
		{
			this.getAnimation(anim);
		}
		;
		for each (channel in node.channel)
		{
			sampler = node.sampler.(@id == channel.@source.substr(1));
			input = node.source.(@id == sampler.input.(@semantic == "INPUT").@source.substr(1));
			output = node.source.(@id == sampler.input.(@semantic == "OUTPUT").@source.substr(1));
			if (output.technique_common.accessor.param.@type.toString() != "float4x4")
			{
			}
			else
			{
				if (int(output.float_array.@count) == 0)
				{
				}
				else
				{
					values = output.float_array.text().split(/\s+/);
					frames = new Vector.<Frame3D>();
					while (values.length)
					{
						frames.push(this.getMatrix(values.splice(0, 16)));
					}
					;
					this._daeAnimation[node.@id.toString()] = frames;
					target = String(channel.@target).split("/")[0];
					if (this._daeSid[target] != undefined)
					{
						this._daeSid[target].frames = frames;
					}
					else
					{
						if (this._daeNodes[target] != undefined)
						{
							this._daeNodes[target].frames = frames;
						}
						;
					}
					;
				}
				;
			}
			;
		}
		;
	}

	private function bindMaterial(node:XMLList, mesh:Mesh3D, technique:FLSLFilter):void
	{
		var instance_material:XML;
		var symbol:String;
		var target:String;
		var material:Shader3D;
		var surface:Surface3D;
		var i:int;
		while (i < node.technique_common.instance_material.length())
		{
			instance_material = node.technique_common.instance_material[i];
			symbol = instance_material.@symbol;
			target = instance_material.@target;
			target = target.substr(1);
			material = this._daeMaterials[target];
			if (!(this._daeMaterials[target]))
			{
				material = new Shader3D(target, this._daeFilters[target], true, technique);
				this._daeMaterials[target] = material;
			}
			;
			for each (surface in mesh.surfaces)
			{
				if (surface.offset[Surface3D.NORMAL] == -1)
				{
					trace("Warning: Missing NORMAL buffer, creating dummy one.");
					surface.addVertexData(Surface3D.NORMAL, 3, new Vector.<Number>(((surface.vertexVector.length / surface.sizePerVertex) * 3)));
				}
				;
				if (surface.offset[Surface3D.UV0] == -1)
				{
					trace("Warning: Missing UV0 buffer, creating dummy one.");
					surface.addVertexData(Surface3D.UV0, 2, new Vector.<Number>(((surface.vertexVector.length / surface.sizePerVertex) * 2)));
				}
				;
				if (this._daeSurfaces[surface] == symbol)
				{
					surface.material = material;
				}
				;
			}
			;
			i++;
		}
		;
		for each (surface in mesh.surfaces)
		{
			if (surface.material == null)
			{
				if (!(this._nullMaterials[technique]))
				{
					this._nullMaterials[technique] = new Shader3D("", [new ColorFilter()], true, technique);
				}
				;
				surface.material = this._nullMaterials[technique];
			}
			;
		}
		;
	}

	private function bindMaterial3(node:XMLList, mesh:Mesh3D, technique:FLSLFilter):void
	{
		var currentNode:XML;
		var i:int;
		var instance_material:XML;
		var symbol:String;
		var target:String;
		var material:Shader3D;
		var surface:Surface3D;
		var j:int;
		var x:int;
		while (x < node.length())
		{
			currentNode = node[x];
			i = 0;
			while (i < currentNode.bind_material.technique_common.instance_material.length())
			{
				instance_material = currentNode.bind_material.technique_common.instance_material[i];
				symbol = instance_material.@symbol;
				target = instance_material.@target;
				target = target.substr(1);
				material = this._daeMaterials[target];
				if (!(this._daeMaterials[target]))
				{
					material = new Shader3D(target, this._daeFilters[target], true, technique);
					this._daeMaterials[target] = material;
				}
				;
				j = 0;
				while (j < this._daeGeometry[currentNode.@url.substr(1)].length)
				{
					surface = this._daeGeometry[currentNode.@url.substr(1)][j];
					if (surface.offset[Surface3D.NORMAL] == -1)
					{
						trace("Warning: Missing NORMAL buffer, creating dummy one.");
						surface.addVertexData(Surface3D.NORMAL, 3, new Vector.<Number>(((surface.vertexVector.length / surface.sizePerVertex) * 3)));
					}
					;
					if (surface.offset[Surface3D.UV0] == -1)
					{
						trace("Warning: Missing UV0 buffer, creating dummy one.");
						surface.addVertexData(Surface3D.UV0, 2, new Vector.<Number>(((surface.vertexVector.length / surface.sizePerVertex) * 2)));
					}
					;
					if (this._daeSurfaces[surface] == symbol)
					{
						surface.material = material;
					}
					;
					j++;
				}
				;
				i++;
			}
			;
			x++;
		}
		;
		for each (surface in mesh.surfaces)
		{
			if (surface.material == null)
			{
				if (!(this._nullMaterials[technique]))
				{
					this._nullMaterials[technique] = new Shader3D("", [new ColorFilter()], true, technique);
				}
				;
				surface.material = this._nullMaterials[technique];
			}
			;
		}
		;
	}

	private function getNode(node:XML):Pivot3D
	{
		var pivot:Pivot3D;
		var mesh:Mesh3D;
		var values:Array;
		var instanceGeometry:XML;
		var instanceUrl:String;
		var t:XML;
		var _local10:Frame3D;
		if (((!((node.@id.toString() == ""))) && (this._daeNodes[node.@id.toString()])))
		{
			return (this._daeNodes[node.@id.toString()]);
		}
		;
		if (node.instance_geometry != undefined)
		{
			mesh = new Mesh3D(((node.@name) || (node.@id)));
			for each (instanceGeometry in node.instance_geometry)
			{
				mesh.surfaces = mesh.surfaces.concat(this._daeGeometry[instanceGeometry.@url.substr(1)]);
			}
			;
			if (mesh.surfaces.length)
			{
				this.bindMaterial3(node.instance_geometry, mesh, Shader3D.VERTEX_NORMAL);
				Mesh3DUtils.split(mesh);
			}
			;
			pivot = mesh;
		}
		else
		{
			if (node.instance_controller != undefined)
			{
				mesh = this._daeControllers[node.instance_controller.@url.substr(1)].mesh;
				mesh.name = node.@name;
				if ((mesh.modifier is SkinModifier))
				{
					this._daeUpdateSkeletons.push(node.instance_controller.skeleton.text());
				}
				;
				this.bindMaterial(node.instance_controller.bind_material, mesh, Shader3D.VERTEX_SKIN);
				pivot = mesh;
			}
			else
			{
				if (node.instance_camera != undefined)
				{
					pivot = this.getCamera(node);
				}
				else
				{
					if (node.instance_light != undefined)
					{
						pivot = this.getLight(node);
					}
					else
					{
						pivot = new Pivot3D(((node.@name) || (node.@id)));
					}
					;
				}
				;
			}
			;
		}
		;
		this._daeNodes[node.@id.toString()] = pivot;
		if (node.instance_node != undefined)
		{
			instanceUrl = node.instance_node.@url.substr(1);
			this._fuckingInstanceNodes.push({pivot: pivot, id: instanceUrl});
		}
		;
		var children:XMLList = node.children();
		var i:int;
		while (i < children.length())
		{
			t = children[i];
			switch (t.localName())
			{
				case "matrix":
					values = t.text().split(/\s+/);
					_local10 = this.getMatrix(values);
					pivot.transform.prepend(_local10);
					break;
				case "translate":
					values = t.text().split(/\s+/);
					pivot.transform.prependTranslation(values[0], values[2], values[1]);
					break;
				case "rotate":
					values = t.text().split(/\s+/);
					pivot.transform.prependRotation(-(values[3]), new Vector3D(values[0], values[2], values[1]));
					break;
				case "scale":
					values = t.text().split(/\s+/);
					pivot.transform.prependScale(values[0], values[2], values[1]);
					break;
				case "node":
					pivot.addChild(this.getNode(t));
					break;
			}
			;
			i++;
		}
		;
		if (node.@sid != undefined)
		{
			this._daeSid[node.@sid] = pivot;
		}
		;
		pivot.updateTransforms();
		return (pivot);
	}

	private function getController(node:XML):Modifier
	{
		var controller:XMLList;
		var mesh:Mesh3D;
		var skin:SkinModifier;
		var daeWeights:XMLList;
		var vWeights:Array;
		var vCount:Array;
		var v:Array;
		var t:int;
		var weightTable:Vector.<Array>;
		var i:int;
		var s:Surface3D;
		var weightVertexArray:Array;
		var e:int;
		var joint:int;
		var weight:int;
		var value:Number;
		var node = node;
		if (node.morph != undefined)
		{
			trace("Morph Controllers are not supported");
			return (null);
		}
		;
		if (this._daeControllers[node.@id])
		{
			return (this._daeControllers[node.@id]);
		}
		;
		if (node.skin)
		{
			controller = node.skin;
			mesh = new Mesh3D(controller.@source);
			mesh.surfaces = this._daeGeometry[controller.@source.substr(1)];
			skin = new SkinModifier();
			skin.mesh = mesh;
			skin.bindTransform.copyFrom(mesh.world);
			this._daeSkinRoots[skin.root] = 1;
			daeWeights = controller.source.(@id == controller.vertex_weights.input.(@semantic == "WEIGHT").@source.substr(1));
			vWeights = daeWeights.float_array.text().split(/\s+/);
			vCount = controller.vertex_weights.vcount.text().split(/\s+/);
			v = controller.vertex_weights.v.text().split(/\s+/);
			t = 0;
			weightTable = new Vector.<Array>();
			i = 0;
			while (i < vCount.length)
			{
				weightVertexArray = [];
				e = 0;
				while (e < vCount[i])
				{
					t = (t + 1);
					joint = v[t];
					t = (t + 1);
					weight = v[t];
					value = vWeights[weight];
					if (value > 0)
					{
						weightVertexArray.push({joint: joint, weight: value});
					}
					;
					e = (e + 1);
				}
				;
				if (weightVertexArray.length > Device3D.maxBonesPerVertex)
				{
					weightVertexArray.sortOn("weight", Array.DESCENDING);
					weightVertexArray.splice(Device3D.maxBonesPerVertex);
				}
				else
				{
					if (weightVertexArray.length > 0)
					{
						while (weightVertexArray.length < Device3D.maxBonesPerVertex)
						{
							weightVertexArray.push({joint: 0, weight: 0});
						}
						;
					}
					;
				}
				;
				weightTable[i] = weightVertexArray;
				i = (i + 1);
			}
			;
			mesh.modifier = skin;
			for each (s in mesh.surfaces)
			{
				extract(weightTable, s, this._daeIndices[s]);
			}
			;
			this._daeControllers[node.@id.toString()] = skin;
			this._daeUpdateControllers.push(node);
			return (skin);
		}
		;
		return (null);
	}

	private function updateController(node:XML):void
	{
		var controller:XMLList;
		var bindMatrix:Frame3D;
		var daeJoints:XMLList;
		var daeInvBindMatrix:XMLList;
		var joints:Array;
		var invMatrix:Array;
		var sid:String;
		var bone:Pivot3D;
		var root:Pivot3D;
		var f:Frame3D;
		var i:int;
		var node = node;
		var skin:SkinModifier = this._daeControllers[node.@id.toString()];
		if (skin)
		{
			controller = node.skin;
			bindMatrix = ((controller.bind_shape_matrix == undefined)) ? new Frame3D() : this.getMatrix(controller.bind_shape_matrix.text().split(/\s+/));
			daeJoints = controller.source.(@id == controller.joints.input.(@semantic == "JOINT").@source.substr(1));
			daeInvBindMatrix = controller.source.(@id == controller.joints.input.(@semantic == "INV_BIND_MATRIX").@source.substr(1));
			if (daeJoints.Name_array != undefined)
			{
				joints = daeJoints.Name_array.text().split(/\s+/);
			}
			else
			{
				if (daeJoints.IDREF_array != undefined)
				{
					joints = daeJoints.IDREF_array.text().split(/\s+/);
				}
				;
			}
			;
			invMatrix = daeInvBindMatrix.float_array.text().split(/\s+/);
			skin.invBoneMatrix = new Vector.<Matrix3D>();
			for each (sid in joints)
			{
				bone = this._daeSid[sid];
				if (this._daeSid[sid] != undefined)
				{
					bone = this._daeSid[sid];
				}
				else
				{
					if (this._daeNodes[sid] != undefined)
					{
						bone = this._daeNodes[sid];
					}
					else
					{
						bone = this.getChildByName(sid);
					}
					;
				}
				;
				skin.addBone(bone);
				skin.invBoneMatrix.push(this.getMatrix(invMatrix.splice(0, 16)));
				skin.invBoneMatrix[(skin.invBoneMatrix.length - 1)].prepend(bindMatrix);
				root = bone;
				while (((((((((!((root.parent == null))) && (!((root.parent == this))))) && ((this._daeSkinRoots[root.parent] == null)))) && (!((root.parent == this._skinRoot))))) && (!((root.parent == this._parent)))))
				{
					root = root.parent;
				}
				;
				root.parent = this._skinRoot;
			}
			;
			skin.root.parent = null;
			skin.root.lock = true;
			skin.root = this._skinRoot;
			skin.update();
			SkinModifier.split(skin, skin.mesh.surfaces);
			if (skin.mesh.frames == null)
			{
				f = new Frame3D(skin.mesh.transform.rawData);
				skin.mesh.transform = f;
				skin.mesh.frames = new Vector.<Frame3D>();
				i = 0;
				while (i < skin.totalFrames)
				{
					skin.mesh.frames.push(f);
					i = (i + 1);
				}
				;
			}
			;
		}
		;
	}

	private function getCamera(node:XML):Camera3D
	{
		var newCamera:Camera3D;
		var currentNode:XMLList;
		var urlString:String = node.instance_camera.@url.toString();
		urlString = urlString.slice(1, urlString.length);
		if (this._daeCameras[urlString])
		{
			return (this._daeCameras[urlString]);
		}
		;
		if (node.optics.technique_common.perspective != undefined)
		{
			newCamera = new Camera3D(((node.@name) || (node.@id)));
			currentNode = node.optics.technique_common.perspective;
			newCamera.fieldOfView = currentNode.yfov;
			newCamera.aspectRatio = currentNode.aspect_ratio;
			newCamera.near = currentNode.znear;
			newCamera.far = currentNode.zfar;
			this._daeCameras[node.@id.toString()] = newCamera;
		}
		;
		return (newCamera);
	}

	private function getLight(node:XML):Light3D
	{
		var newLight:Light3D;
		var currentNode:XMLList;
		var explodedColors:Array;
		var urlString:String = node.instance_light.@url.toString();
		urlString = urlString.slice(1, urlString.length);
		if (this._daeLights[urlString])
		{
			return (this._daeLights[urlString]);
		}
		;
		if (node.technique_common.point != undefined)
		{
			currentNode = node.technique_common.point;
			explodedColors = currentNode.color.toString().split(" ");
			newLight = new Light3D(((node.@name) || (node.@id)));
			newLight.color.x = explodedColors[0];
			newLight.color.y = explodedColors[1];
			newLight.color.z = explodedColors[2];
			newLight.attenuation = Number(currentNode.constant_attenuation);
			this._daeLights[node.@id.toString()] = newLight;
		}
		else
		{
			if (node.technique_common.ambient != undefined)
			{
				newLight = new Light3D(((node.@name) || (node.@id)));
				this._daeLights[node.@id.toString()] = newLight;
			}
			else
			{
				newLight = new Light3D(((node.@name) || (node.@id)));
				this._daeLights[node.@id.toString()] = newLight;
			}
			;
		}
		;
		return (newLight);
	}

	private function uintSplit(str:String, out:Vector.<uint> = null):Vector.<uint>
	{
		var i:int;
		var e:int;
		var idx:int;
		var s:String;
		if (!(out))
		{
			out = new Vector.<uint>();
		}
		;
		var space:String = " ";
		var l:int = str.length;
		while (i < l)
		{
			s = str.charAt(i);
			if (s == space)
			{
				i++;
				var _temp1 = idx;
				idx = (idx + 1);
				var _local9 = _temp1;
				out[_local9] = uint(str.substring(e, i));
				e = i;
			}
			;
			i++;
		}
		;
		var _temp2 = idx;
		idx = (idx + 1);
		_local9 = _temp2;
		out[_local9] = uint(str.substring(e, i));
		return (out);
	}

	private function numberSplit(str:String, out:Vector.<Number> = null):Vector.<Number>
	{
		var i:int;
		var e:int;
		var idx:int;
		if (!(out))
		{
			out = new Vector.<Number>();
		}
		;
		while (true)
		{
			e = i;
			i = str.indexOf(" ", i);
			if (i != -1)
			{
				var _temp1 = idx;
				idx = (idx + 1);
				var _local6 = _temp1;
				var _temp2 = e;
				var _temp3 = i;
				i = (i + 1);
				out[_local6] = Number(str.substring(_temp2, _temp3));
			}
			else
			{
				break;
			}
			;
		}
		;
		var _temp4 = idx;
		idx = (idx + 1);
		_local6 = _temp4;
		out[_local6] = Number(str.substring(e));
		return (out);
	}

	private function getGeometry(node:XML):Vector.<Surface3D>
	{
		var sources:Array;
		var src:XML;
		var primitive:XMLList;
		var tri:XML;
		var inputs:Vector.<Object>;
		var surf:Surface3D;
		var colorSet:int;
		var uvSet:int;
		var indices:Vector.<uint>;
		var p:XML;
		var input:Object;
		var inputLength:int;
		var vert:int;
		var index:int;
		var indicesLength:int;
		var e:int;
		var count:int;
		var length:int;
		var tCount:int;
		var pIndex:int;
		var arr:Array;
		var i:int;
		var inputType:int;
		var inputSize:int;
		var vCount:Array;
		var node = node;
		if (this._daeGeometry[node.@id])
		{
			return (this._daeGeometry[node.@id]);
		}
		;
		var surfaces:Vector.<Surface3D> = new Vector.<Surface3D>();
		var lastLength:uint;
		this._daeGeometry[node.@id.toString()] = surfaces;
		if (node.mesh != undefined)
		{
			sources = [];
			for each (src in node.mesh.source)
			{
				sources[src.@id.toString()] = {values: this.numberSplit(src.float_array), stride: src.technique_common.accessor.@stride};
			}
			;
			if (node.mesh.triangles != undefined)
			{
				primitive = node.mesh.triangles;
			}
			;
			if (node.mesh.polygons != undefined)
			{
				primitive = node.mesh.polygons;
			}
			;
			if (node.mesh.polylist != undefined)
			{
				primitive = node.mesh.polylist;
			}
			;
			if (primitive)
			{
				for each (tri in primitive)
				{
					var readInputs:Function = function(inputList:XMLList):void
					{
						var input:XML;
						for each (input in inputList)
						{
							switch (input.@semantic.toString())
							{
								case "POSITION":
									inputs.push({inputType: Surface3D.POSITION, inputSize: 3, source: sources[input.@source.substr(1)], offset: ((input.@offset == undefined)) ? 0 : input.@offset});
									break;
								case "NORMAL":
									inputs.push({inputType: Surface3D.NORMAL, inputSize: 3, source: sources[input.@source.substr(1)], offset: ((input.@offset == undefined)) ? 0 : input.@offset});
									break;
								case "TEXCOORD":
									inputs.push({inputType: Surface3D[("UV" + uvSet++)], inputSize: 2, source: sources[input.@source.substr(1)], offset: ((input.@offset == undefined)) ? 0 : input.@offset});
									break;
								case "COLOR":
									inputs.push({inputType: Surface3D[("COLOR" + colorSet++)], inputSize: 3, source: sources[input.@source.substr(1)], offset: ((input.@offset == undefined)) ? 0 : input.@offset});
									break;
								case "VERTEX":
									break;
								default:
									trace("Weird input", input.@semantic.toString());
							}
							;
						}
						;
					};
					var pushVertex:Function = function(index:int):void
					{
						var values:Vector.<Number>;
						var stride:int;
						var offset:int;
						index = (index * inputLength);
						for each (input in inputs)
						{
							values = input.source.values;
							stride = input.source.stride;
							offset = input.offset;
							vert = (indices[(index + offset)] * stride);
							if (offset == 0)
							{
								_daeIndices[surf].push(indices[index]);
							}
							;
							if ((((input.inputType == Surface3D.COLOR0)) || ((input.inputType == Surface3D.COLOR1))))
							{
								surf.vertexVector.push(values[vert], values[(vert + 1)], values[(vert + 2)]);
							}
							else
							{
								if (input.inputSize == 3)
								{
									surf.vertexVector.push(values[vert], values[(vert + 2)], values[(vert + 1)]);
								}
								else
								{
									surf.vertexVector.push(values[vert], -(values[(vert + 1)]));
								}
								;
							}
							;
						}
						;
					};
					inputs = new Vector.<Object>();
					surf = new Surface3D(node.@id);
					colorSet = 0;
					uvSet = 0;
					this._daeSurfaces[surf] = tri.@material.toString();
					readInputs(node.mesh.vertices.input);
					readInputs(tri.input);
					indices = new Vector.<uint>();
					for each (p in tri.p)
					{
						arr = p.text().split(" ");
						for each (i in arr)
						{
							indices.push(i);
						}
						;
					}
					;
					inputLength = 0;
					for each (input in inputs)
					{
						inputType = input.inputType;
						inputSize = input.inputSize;
						surf.addVertexData(inputType, inputSize);
						if (int(input.offset) > inputLength)
						{
							inputLength = int(input.offset);
						}
						;
					}
					;
					inputLength = (inputLength + 1);
					index = 0;
					indicesLength = indices.length;
					this._daeIndices[surf] = new Vector.<uint>();
					length = (indicesLength / inputLength);
					tCount = 0;
					pIndex = 0;
					if (node.mesh.polylist != undefined)
					{
						vCount = tri.vcount.text().split(" ");
						index = 0;
						while (index < length)
						{
							pIndex = (pIndex + 1);
							count = vCount[pIndex];
							e = 1;
							while (e < (count - 1))
							{
								pushVertex(((index + e) + 1));
								pushVertex((index + e));
								pushVertex(index);
								tCount = (tCount + 1);
								tCount = (tCount + 1);
								tCount = (tCount + 1);
								surf.indexVector.push(tCount, tCount, tCount);
								e = (e + 1);
							}
							;
							index = (index + count);
						}
						;
					}
					else
					{
						if (node.mesh.polygons != undefined)
						{
							index = 0;
							while (index < length)
							{
								pIndex = (pIndex + 1);
								count = (int(tri.p[pIndex].text().split(" ").length) / inputLength);
								e = 1;
								while (e < (count - 1))
								{
									pushVertex(((index + e) + 1));
									pushVertex((index + e));
									pushVertex(index);
									tCount = (tCount + 1);
									tCount = (tCount + 1);
									tCount = (tCount + 1);
									surf.indexVector.push(tCount, tCount, tCount);
									e = (e + 1);
								}
								;
								index = (index + count);
							}
							;
						}
						else
						{
							index = 0;
							while (index < length)
							{
								pushVertex(index);
								surf.indexVector.unshift(index);
								index = (index + 1);
							}
							;
						}
						;
					}
					;
					if (this._flipNormals)
					{
						Surface3DUtils.flipNormals(surf);
					}
					;
					if (surf.indexVector.length)
					{
						surfaces.push(surf);
					}
					;
				}
				;
			}
			;
		}
		;
		return (surfaces);
	}

	private function getMatrix(values:Array):Frame3D
	{
		var matrix:Frame3D = new Frame3D();
		matrix.copyColumnFrom(0, new Vector3D(values[0], values[2], values[1], values[3]));
		matrix.copyColumnFrom(2, new Vector3D(values[4], values[6], values[5], values[7]));
		matrix.copyColumnFrom(1, new Vector3D(values[8], values[10], values[9], values[11]));
		matrix.copyColumnFrom(3, new Vector3D(values[12], values[14], values[13], values[15]));
		matrix.transpose();
		return (matrix);
	}

	private function get libraryContext():Library3D
	{
		if (this._sceneContext)
		{
			return (this._sceneContext.library);
		}
		;
		if (scene)
		{
			return (scene.library);
		}
		;
		return (this._library);
	}

	public function get request()
	{
		return (this._request);
	}

	public static function extract(weightTable:Vector.<Array>, surface:Surface3D, indices:Vector.<uint>):void
	{
		var index:int;
		var data:Array;
		var sum:Number;
		var sumIndex:int;
		var rest:Number;
		var vertexWeights:Vector.<Number> = new Vector.<Number>();
		var vertexIndices:Vector.<Number> = new Vector.<Number>();
		var i:int;
		while (i < indices.length)
		{
			index = indices[i];
			data = ((index < weightTable.length)) ? weightTable[index] : null;
			if ((((data == null)) || ((data.length == 0))))
			{
				switch (Device3D.maxBonesPerVertex)
				{
					case 4:
						vertexWeights.push(1, 0, 0, 0);
						vertexIndices.push(0, 0, 0, 0);
						break;
					case 3:
						vertexWeights.push(1, 0, 0);
						vertexIndices.push(0, 0, 0);
						break;
					case 2:
						vertexWeights.push(1, 0);
						vertexIndices.push(0, 0);
						break;
					case 1:
						vertexWeights.push(1);
						vertexIndices.push(0);
						break;
				}
				;
			}
			else
			{
				sum = 0;
				sumIndex = 0;
				while (sumIndex < Device3D.maxBonesPerVertex)
				{
					sum = (sum + data[sumIndex].weight);
					sumIndex++;
				}
				;
				if ((((sum < 0.99)) || ((sum > 1.01))))
				{
					rest = (1 - sum);
					sumIndex = 0;
					while (sumIndex < Device3D.maxBonesPerVertex)
					{
						data[sumIndex].weight = (data[sumIndex].weight + ((data[sumIndex].weight / sum) * rest));
						sumIndex++;
					}
					;
				}
				;
				switch (Device3D.maxBonesPerVertex)
				{
					case 4:
						vertexWeights.push(data[0].weight, data[1].weight, data[2].weight, data[3].weight);
						vertexIndices.push((data[0].joint * 3), (data[1].joint * 3), (data[2].joint * 3), (data[3].joint * 3));
						break;
					case 3:
						vertexWeights.push(data[0].weight, data[1].weight, data[2].weight);
						vertexIndices.push((data[0].joint * 3), (data[1].joint * 3), (data[2].joint * 3));
						break;
					case 2:
						vertexWeights.push(data[0].weight, data[1].weight);
						vertexIndices.push((data[0].joint * 3), (data[1].joint * 3));
						break;
					case 1:
						vertexWeights.push(1);
						vertexIndices.push((data[0].joint * 3));
						break;
				}
				;
			}
			;
			i++;
		}
		;
		surface.addVertexData(Surface3D.SKIN_WEIGHTS, Device3D.maxBonesPerVertex, vertexWeights);
		surface.addVertexData(Surface3D.SKIN_INDICES, Device3D.maxBonesPerVertex, vertexIndices);
	}

}
