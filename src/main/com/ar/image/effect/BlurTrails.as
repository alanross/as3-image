package com.ar.image.effect
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class BlurTrails implements IEffect
	{
		private const origin:Point = new Point();

		private var _input:BitmapData;
		private var _output:BitmapData;
		private var _filter:BlurFilter;

		/**
		 * Creates a new instance of BlurTrails.
		 */
		public function BlurTrails( input:BitmapData, output:BitmapData, blurFilter:BlurFilter )
		{
			_input = input;
			_output = output;
			_filter = blurFilter;
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			_output.copyPixels( _input, _input.rect, origin );
			_input.applyFilter( _output, _output.rect, origin, _filter );
		}

		/**
		 * Creates and returns a string representation of the BlurTrails object.
		 */
		public function toString():String
		{
			return "[BlurTrails]";
		}
	}
}