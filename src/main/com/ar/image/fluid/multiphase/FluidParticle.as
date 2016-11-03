package com.ar.image.fluid.multiphase
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FluidParticle
	{
		public var next:FluidParticle;
		public var color:uint = 0x808080;

		public var node:FluidNode;

		public var mass:Number = 1.0;
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var u:Number = 0.0;
		public var v:Number = 0.0;

		public var rd:Number = 1.0;
		public var k:Number = 1.0;
		public var gas:Boolean;

		public var px0:Number;
		public var px1:Number;
		public var px2:Number;
		public var py0:Number;
		public var py1:Number;
		public var py2:Number;

		public var gx0:Number;
		public var gx1:Number;
		public var gx2:Number;
		public var gy0:Number;
		public var gy1:Number;
		public var gy2:Number;

		public var p00:Number;
		public var p10:Number;
		public var p20:Number;
		public var p01:Number;
		public var p11:Number;
		public var p21:Number;
		public var p02:Number;
		public var p12:Number;
		public var p22:Number;

		public function FluidParticle()
		{
		}

		public function toString():String
		{
			return "[FluidParticle]";
		}
	}
}