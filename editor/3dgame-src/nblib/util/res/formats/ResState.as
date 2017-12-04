package nblib.util.res.formats
{

	/**
	 * 资源状态常量集
	 * @author zhanghaocong
	 * @see Res#state
	 */
	public class ResState
	{
		/**
		 * 空闲中
		 */
		public static const Idle:int = 1;

		/**
		 * 正在下载
		 */
		public static const LoadInProgress:int = 2;

		/**
		 * 已下载完毕
		 */
		public static const LoadComplete:int = 3;

		/**
		 * 下载时出现错误
		 */
		public static const Error:int = 4;
	}
}
