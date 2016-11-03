package com.ar.image.filter.sobel
{
	import com.ar.image.filter.*;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;

	/**
	 * An approximation of the Sobel filter utilizing Convolution filters.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class SobelQuickFilter
	{
		// Values are between 0 and 255 when the filter is applied, to enable
		// negative values to be held by the image the 127 as added allowing
		// values smaller than 127 to be handled as negative
		private static const sobelH127:ConvolutionFilter = FilterUtils.sobelH127();
		private static const sobelV127:ConvolutionFilter = FilterUtils.sobelV127();

		private static const sobelH:ConvolutionFilter = FilterUtils.sobelH();
		private static const sobelV:ConvolutionFilter = FilterUtils.sobelV();

		private static const zero:Point = new Point();
		private static const gauss:ConvolutionFilter = FilterUtils.gauss3x3();
		private static const grey:ColorMatrixFilter = FilterUtils.greyScale();

		private var _output:BitmapData;

		/**
		 * Creates a new instance of SobelQuickFilter.
		 */
		public function SobelQuickFilter()
		{
		}

		/**
		 * Apply the sobel filter to given input.
		 */
		public function apply( input:BitmapData ):BitmapData
		{
			var source:BitmapData = input.clone(); // copy input, as we don't want to destruct input
			var filter:BitmapData = input.clone();

			_output = input.clone();
			_output.fillRect( _output.rect, 0xFF000000 );

			source.applyFilter( input, input.rect, zero, grey );
			source.applyFilter( source, source.rect, zero, gauss );

			filter.applyFilter( source, source.rect, zero, sobelH );
			_output.applyFilter( source, source.rect, zero, sobelV );
			_output.draw( filter, null, null, BlendMode.ADD );

			return _output;
		}

		/**
		 * Apply the sobel filter to given input while keeping the hor and ver result in the green and blue channel
		 * of the resulting image.
		 */
		public function applyHVSeparate( input:BitmapData ):BitmapData
		{
			var source:BitmapData = input.clone(); // copy input, as we don't want to destruct input
			var filter:BitmapData = input.clone();

			_output = input.clone();
			_output.fillRect( _output.rect, 0xFF000000 );

			source.applyFilter( input, input.rect, zero, grey );
			source.applyFilter( source, source.rect, zero, gauss );

			// horizontal, encoded in blue
			filter.applyFilter( source, source.rect, zero, sobelH127 );
			_output.copyChannel( filter, filter.rect, zero, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE );

			// vertical, encoded in green
			filter.applyFilter( source, source.rect, zero, sobelV127 );
			_output.copyChannel( filter, filter.rect, zero, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN );

			return _output;
		}

		/**
		 * Returns a horizontal Sobel force value between 0 and 255.
		 */
		public function getForceH( x:int, y:int ):int
		{
			const pixel:int = _output.getPixel( x, y );

			// note that we subtract the 127 that were added earlier to encode minus values
			return ( pixel & 0xff ) - 127; //blue
		}

		/**
		 * Returns a vertical Sobel force value between 0 and 255.
		 */
		public function getForceV( x:int, y:int ):int
		{
			const pixel:int = _output.getPixel( x, y );

			return ( ( pixel >> 8 ) & 0xff ) - 127; //green
		}

		/**
		 * Returns a horizontal Sobel force value between 0 and 1.
		 */
		public function getForceHNormalized( x:int, y:int ):Number
		{
			const pixel:int = _output.getPixel( x, y );

			return ( ( ( pixel & 0xff ) - 127 ) / 255.0 ); // blue
		}

		/**
		 * Returns a vertical Sobel force value between 0 and 1.
		 */
		public function getForceVNormalized( x:int, y:int ):Number
		{
			const pixel:int = _output.getPixel( x, y );

			return ( ( ( ( pixel >> 8 ) & 0xff ) - 127 ) / 255.0 ); //green
		}

		/**
		 * Returns as an radian force value calculated by the atan of the hor and ver values.
		 */
		public function getForceRadian( x:int, y:int ):int
		{
			const pixel:int = _output.getPixel( x, y );

			var fh:Number = ( pixel & 0xff ) - 127; //blue
			var fv:Number = ( ( pixel >> 8 ) & 0xff ) - 127; //green

			return Math.atan2( fh, fv );
		}

		/**
		 * The filtered image
		 */
		public function get output():BitmapData
		{
			return _output;
		}

		/**
		 * Creates and returns a string representation of the SobelQuickFilter object.
		 */
		public function toString():String
		{
			return "[SobelQuickFilter]";
		}
	}
}