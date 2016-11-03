package com.ar.image.effect
{
	import com.ar.image.filter.FilterUtils;

	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Very dark colors will start to "glitter"
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class DarkGlitter implements IEffect
	{
		private const origin:Point = new Point();
		private const quirk:ColorTransform = FilterUtils.quirk( 2, 255, 255, 255 );
		private const invert:ColorMatrixFilter = FilterUtils.negative();
		private const blur:BlurFilter = new BlurFilter( 3, 3, 3 );
		private const multiply:int = (256 / 100.0) * 60;

		private var _input:BitmapData;
		private var _output:BitmapData;

		/**
		 * Creates a new instance of BlackGlitter.
		 * Make sure input and output are pixel32.
		 */
		public function DarkGlitter( input:BitmapData, output:BitmapData )
		{
			_input = input;
			_output = output;
		}

		/**
		 * @inheritDoc
		 */
		public function apply():void
		{
			var rect:Rectangle = _output.rect;

			_output.draw( _input );
			_output.draw( _output, null, quirk );
			_output.applyFilter( _output, rect, origin, invert );
			_output.applyFilter( _output, rect, origin, blur );
			_output.merge( _input, rect, origin, multiply, multiply, multiply, multiply );
		}

		/**
		 * Creates and returns a string representation of the DarkGlitter object.
		 */
		public function toString():String
		{
			return "[DarkGlitter]";
		}
	}
}