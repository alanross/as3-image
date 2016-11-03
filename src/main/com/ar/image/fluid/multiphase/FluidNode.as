package com.ar.image.fluid.multiphase
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FluidNode
	{
		public var m:Number = 0;
		public var d:Number = 0;
		public var gx:Number = 0;
		public var gy:Number = 0;
		public var u:Number = 0;
		public var v:Number = 0;
		public var ax:Number = 0;
		public var ay:Number = 0;
		public var active:Boolean;

		public var next:FluidNode;

		public var n10:FluidNode;
		public var n20:FluidNode;
		public var n01:FluidNode;
		public var n11:FluidNode;
		public var n21:FluidNode;
		public var n02:FluidNode;
		public var n12:FluidNode;
		public var n22:FluidNode;

		public function FluidNode()
		{
		}

		public function clear():void
		{
			m = d = gx = gy = u = v = ax = ay = 0;
			active = false;
		}

		public function toString():String
		{
			return "[FluidNode]";
		}
	}
}