package diary.util
{
	import flare.core.IComponent;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.flsl.FLSLFilter;
	import flare.materials.Shader3D;

	public class FilterComponent implements IComponent
	{
		private var filter:FLSLFilter;
		private var target:Pivot3D;

		public function FilterComponent(filter:FLSLFilter)
		{
			this.filter = filter;
		}

		public function added(target:Pivot3D):Boolean
		{
			return true;
			this.target = target;
			target.forEach(function(mesh:Mesh3D):void
			{
				for each (var surf:Surface3D in mesh.surfaces)
				{
					if (Shader3D(surf.material).filters.indexOf(filter) == -1)
					{
						Shader3D(surf.material).filters.push(filter);
						Shader3D(surf.material).build();
					}
				}
			}, Mesh3D)
			return true;
		}

		public function removed():Boolean
		{
			return true;
			target.forEach(function(mesh:Mesh3D):void
			{
				for each (var surf:Surface3D in mesh.surfaces)
				{
					var index:int = Shader3D(surf.material).filters.indexOf(filter)
					if (index != -1)
					{
						Shader3D(surf.material).filters.splice(index, 1);
						Shader3D(surf.material).build();
					}
				}
			}, Mesh3D);
			return true;
		}
	}
}
