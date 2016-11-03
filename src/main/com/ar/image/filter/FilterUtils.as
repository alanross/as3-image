package com.ar.image.filter
{
	import com.ar.math.Maths;

	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FilterUtils
	{
		private static const lr:Number = 0.213;
		private static const lg:Number = 0.715;
		private static const lb:Number = 0.072;

		/**
		 *
		 */
		public static function quirk( amount:int = 2, r:int = 100, g:int = 100, b:int = 100 ):ColorTransform
		{
			var value:int = ( 256 + amount );

			var dr:Number = 100 / ( ( value - r ) / 256 );
			var dg:Number = 100 / ( ( value - g ) / 256 );
			var db:Number = 100 / ( ( value - b ) / 256 );

			return new ColorTransform( dr / 100, dg / 100, db / 100, 1, 0, 0, 0, 0 );
		}

		/**
		 * True grey scale of the image
		 */
		public static function greyScale():ColorMatrixFilter
		{
			const v:Number = 0.33;

			return new ColorMatrixFilter(
					[v, v, v, 0, 0,
					 v, v, v, 0, 0,
					 v, v, v, 0, 0,
					 0, 0, 0, 1, 0]
			);
		}

		/**
		 * Red scale of image
		 */
		public static function redScale():ColorMatrixFilter
		{
			const v:Number = 0.33;

			return new ColorMatrixFilter(
					[v, v, v, 0, 0,
					 0, 0, 0, 0, 0,
					 0, 0, 0, 0, 0,
					 0, 0, 0, 1, 0]
			);
		}

		/**
		 * Green scale of image
		 */
		public static function greenScale():ColorMatrixFilter
		{
			const v:Number = 0.33;

			return new ColorMatrixFilter(
					[0, 0, 0, 0, 0,
					 v, v, v, 0, 0,
					 0, 0, 0, 0, 0,
					 0, 0, 0, 1, 0]
			);
		}

		/**
		 * Blue scale of image
		 */
		public static function blueScale():ColorMatrixFilter
		{
			const v:Number = 0.33;

			return new ColorMatrixFilter(
					[0, 0, 0, 0, 0,
					 0, 0, 0, 0, 0,
					 v, v, v, 0, 0,
					 0, 0, 0, 1, 0]
			);
		}

		/**
		 * Negative of the image.
		 */
		public static function negative():ColorMatrixFilter
		{
			return new ColorMatrixFilter( [ -1 , 0, 0, 0, 255,
											0 , -1, 0, 0, 255,
											0 , 0, -1, 0, 255,
											0, 0, 0, 1, 0] );
		}

		/**
		 * Saturation. [ 0, 1 ]
		 */
		public static function saturation( value:Number ):ColorMatrixFilter
		{
			value = Maths.clamp( value, 0.0, 1.0 ) * 255;

			const iv:Number = 1.0 - value;

			const ilr:Number = iv * lr;
			const ilg:Number = iv * lg;
			const ilb:Number = iv * lb;

			const m:Array = [ilr + value, ilg, ilb, 0, 0,
							 ilr, ilg + value, ilb, 0, 0,
							 ilr, ilg, ilb + value, 0, 0,
							 0, 0, 0, 1, 0 ];

			return new ColorMatrixFilter( m );
		}

		/**
		 * Contrast. [ 0, 1 ]
		 */
		public static function contrast( value:Number ):ColorMatrixFilter
		{
			value = Maths.clamp( value, 0.0, 1.0 ) * 255;

			value += 1;

			var mat:Array = [value, 0, 0, 0, 128 * (1 - value),
							 0, value, 0, 0, 128 * (1 - value),
							 0, 0, value, 0, 128 * (1 - value),
							 0, 0, 0, 1, 0];


			return new ColorMatrixFilter( mat );
		}

		/**
		 * Hue. [ 0, 1 ]
		 */
		public static function hue( value:Number ):ColorMatrixFilter
		{
			value = ( Maths.clamp( value, 0.0, 1.0 ) * 360 ) * Math.PI / 180;

			var c:Number = Math.cos( value );
			var s:Number = Math.sin( value );

			var mat:Array = [(lr + (c * (1 - lr))) + (s * (-lr)), (lg + (c * (-lg))) + (s * (-lg)), (lb + (c * (-lb))) + (s * (1 - lb)), 0, 0, (lr + (c * (-lr))) + (s * 0.143), (lg + (c * (1 - lg))) + (s * 0.14), (lb + (c * (-lb))) + (s * -0.283), 0, 0, (lr + (c * (-lr))) + (s * (-(1 - lr))), (lg + (c * (-lg))) + (s * lg), (lb + (c * (1 - lb))) + (s * lb), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];

			return new ColorMatrixFilter( mat );
		}

		/**
		 * Brightness. [ -1, +1 ]
		 */
		public static function brightness( value:Number = 0 ):ColorMatrixFilter
		{
			value = Maths.clamp( value, -1.0, 1.0 ) * 0xFF;

			return new ColorMatrixFilter(
					[1, 0, 0, 0, value,
					 0, 1, 0, 0, value,
					 0, 0, 1, 0, value,
					 0, 0, 0, 1, 0]
			);
		}

		/**
		 * Photocopy. [ 0, 1 ]
		 */
		public static function photocopy( times:Number ):ConvolutionFilter
		{
			times = 1 + Maths.clamp( times, 0.0, 1.0 ) * 20;

			return new ConvolutionFilter( 3, 3, [ -times, times, -times, 1, 1, times, -times, times, -1], 1 );
		}

		/**
		 * Identity filter.
		 */
		public static function none():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ 0, 0, 0, 0, 1, 0, 0, 0, 0 ], 1 );
		}

		/**
		 * Simple blur
		 */
		public static function blur():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ 0, 1, 0, 1, 1, 1, 0, 1, 0], 5 );
		}

		/**
		 * Simple mean
		 */
		public static function mean():ConvolutionFilter
		{
			var v:Number = 1.0 / 9.0;
			return new ConvolutionFilter( 3, 3, [ v, v, v, v, v, v, v, v, v ], 1 );
		}

		/**
		 * Simple smooth/gaussian filter.
		 */
		public static function gauss3x3():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ 1, 2, 1, 2, 4, 2, 1, 2, 1 ], 16 );
		}

		/**
		 * Simple gaussian filter.
		 */
		public static function gauss5x5():ConvolutionFilter
		{
			return new ConvolutionFilter( 5, 5, [ 2, 4, 5, 4, 2, 4, 9, 12, 9, 4, 5, 12, 15, 12, 5, 4, 9, 12, 9, 4, 2, 4, 5, 4, 2  ], 159 );
		}

		/**
		 * Simple sharpen
		 */
		public static function sharpen():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ 0, -1, 0, -1, 5, -1, 0, -1, 0 ], 1 );
		}

		/**
		 * A little more contrast/sharpening
		 */
		public static function enhance():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ 0, -2, 0, -2, 20, -2, 0, -2, 0 ], 10, -40 );
		}

		/**
		 * Relief/emboss effect
		 */
		public static function emboss():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ -2, -1, 0, -1, 1, 1, 0, 1, 2 ], 1 );
		}

		/**
		 * Simple detection of high contrast areas
		 */
		public static function outline( clarity:int = 30, darkness:int = 9 ):ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ -clarity, clarity, 0, -clarity, clarity, 0, -clarity, clarity, 0 ], darkness );
		}

		/**
		 * Simple detection of high contrast areas
		 */
		public static function outlineFixed():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [0, 20, 0, 20, -80, 20, 0, 20, 0 ], 10 );
		}

		/**
		 * Used to enhance discontinuities.
		 */
		public static function laplace():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ 0, -1, 0, -1, 4, -1, 0, -1, 0], 1 );
		}

		/**
		 * Enhances high-frequency parts, used to sharpen images.
		 */
		public static function highPass():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [-1, -1, -1, -1, 9, -1, -1, -1, -1] );
		}

		/**
		 *
		 */
		public static function lowPass():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1], 0.9 );
		}

		/**
		 * Detects vertical changes. If SobelV&H are applied, on can compute the
		 * magnitude and direction of the edges.
		 */
		public static function sobelV():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [-1, -2, -1, 0, 0, 0, 1, 2, 1], 1 );
		}

		/**
		 * Detects horizontal changes. If SobelV&H are applied, on can compute the
		 * magnitude and direction of the edges.
		 */
		public static function sobelH():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [-1, 0, 1, -2, 0, 2, -1, 0, 1], 1 );
		}

		/**
		 * Detects vertical changes. If SobelV&H are applied, on can compute the
		 * magnitude and direction of the edges.
		 */
		public static function sobelV127():ConvolutionFilter
		{
			// Adding 127 preserves minus values from being clamped to [0-255] letting 127 be the 0
			return new ConvolutionFilter( 3, 3, [ -1, 0, 1, -2, 0, 2, -1, 0, 1 ], 1, 127 );
		}

		/**
		 * Detects horizontal changes. If SobelV&H are applied, on can compute the
		 * magnitude and direction of the edges.
		 */
		public static function sobelH127():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [ -1, -2, -1, 0, 0, 0, 1, 2, 1 ], 1, 127 );
		}

		/**
		 *
		 */
		public static function edgeDetection():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [-1, -1, -1, -1, 8, -1, -1, -1, -1], 1 );
		}

		/**
		 *
		 */
		public static function edgeDetectionStrong():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [1, -2, 1, -2, 4, -2, 1, -2, 1], 1 );
		}

		/**
		 * Detect vertical lines in image.
		 */
		public static function lineDetectionVertical():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [-1, 2, -1, -1, 2, -1, -1, 2, -1], 1 );
		}

		/**
		 * Detect horizontal lines in image.
		 */
		public static function lineDetectionHorizontal():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [-1, -1, -1, 2, 2, 2, -1, -1, -1], 1 );
		}

		/**
		 * Detect diagonal lines in image.
		 */
		public static function lineDetectionDiagonalLeft():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [2, -1, -1, -1, 2, -1, -1, -1, 2], 1 );
		}

		/**
		 * Detect diagonal lines in image.
		 */
		public static function lineDetectionDiagonalRight():ConvolutionFilter
		{
			return new ConvolutionFilter( 3, 3, [-1, -1, 2, -1, 2, -1, 2, -1, -1], 1 );
		}

		/**
		 * Creates a new instance of FilterUtils.
		 */
		public function FilterUtils()
		{
			throw new Error( "ConvolutionFilterUtils class is static container only." );
		}

		/**
		 * Creates and returns a string representation of the FilterUtils object.
		 */
		public function toString():String
		{
			return "[ConvolutionFilterUtils]";
		}
	}
}