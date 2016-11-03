package com.ar.image.contour
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class ContourPoint
	{
		public var x:int;
		public var y:int;

		public function ContourPoint( x:int = 0, y:int = 0 )
		{
			this.x = x;
			this.y = y;
		}

		public function equals( p:ContourPoint ):Boolean
		{
			return x == p.x && y == p.y;
		}

		public function toString():String
		{
			return "[ContourPoint x:" + x + ", y:" + y + "]";
		}
	}
}