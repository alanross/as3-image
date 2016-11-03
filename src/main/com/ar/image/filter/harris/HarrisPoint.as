package com.ar.image.filter.harris
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class HarrisPoint
	{
		public var x:int = 0;
		public var y:int = 0;
		public var val:Number = 0.0;

		public function HarrisPoint( x:int, y:int, val:Number )
		{
			this.x = x;
			this.y = y;
			this.val = val;
		}

		public function toString():String
		{
			return "[HarrisPoint x:" + x + ", y:" + y + ", val:" + val + "]";
		}
	}
}