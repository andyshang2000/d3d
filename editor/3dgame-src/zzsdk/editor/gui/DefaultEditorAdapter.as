package zzsdk.editor.gui
{
	import flash.events.MouseEvent;

	import zzsdk.editor.EditorBase;
	import zzsdk.editor.IEditor;

	public class DefaultEditorAdapter extends EditorBase implements IEditor
	{
		public function DefaultEditorAdapter()
		{
			infoPanel.qdrxButton.addEventListener(MouseEvent.CLICK, qdrxClick);
			infoPanel.apkButton.addEventListener(MouseEvent.CLICK, apkClick);
			infoPanel.ipaButton.addEventListener(MouseEvent.CLICK, ipaClick);
			infoPanel.previewButton.addEventListener(MouseEvent.CLICK, previewClick);
		}

		protected function previewClick(event:MouseEvent):void
		{
			preview();
		}

		protected function ipaClick(event:MouseEvent):void
		{
			infoPanel.saveIcon();
			exportIPA(infoPanel.debugCheckBox.selected);
		}

		protected function apkClick(event:MouseEvent):void
		{
			infoPanel.saveIcon();
			exportAPK(infoPanel.debugCheckBox.selected);
		}

		protected function qdrxClick(event:MouseEvent):void
		{
			infoPanel.saveIcon();
			saveQdrx();
		}
	}
}
