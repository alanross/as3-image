package com.ar.image.fractals.lindenmayer
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class LTurtle
	{
		public var x:Number;
		public var y:Number;
		public var angle:Number;
		public var level:Number;
		public var color:int;

		public function LTurtle( x:Number, y:Number, angle:Number, level:int, color:int = -1 )
		{
			this.x = x;
			this.y = y;
			this.angle = angle;
			this.level = level;
			this.color = color;
		}

		public function clone():LTurtle
		{
			return new LTurtle( x, y, angle, level, color );
		}

		public function toString():String
		{
			return "[LTurtle x:" + x + ", y:" + y + ", angle:" + angle + "]";
		}
	}

}