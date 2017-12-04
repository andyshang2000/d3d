package shaders
{
	import flash.utils.ByteArray;

	import flare.flsl.FLSLFilter;
	import flare.materials.Shader3D;

	[Embed(source = "edgeFilter.flsl.compiled", mimeType = "application/octet-stream")]
	public class EdgeShader extends ByteArray
	{
		public var filter:FLSLFilter

		public function EdgeShader()
		{
			filter = new FLSLFilter(this);
			filter.params.edge.value = Vector.<Number>([0.25]);
			filter.params.da.value = Vector.<Number>([0.02]);
			filter.params.color.value = Vector.<Number>([0, 0, 0, 0.5]);
		}
		
		public function apply(shader:Shader3D):void
		{
			if (shader.filters.indexOf(filter) != -1)
				return;
			shader.filters.push(filter);
		}
	}
}
