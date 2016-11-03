package com.ar.image.filter.harris
{
	import com.ar.image.filter.sobel.SobelQuickFilter;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * An approximation of the Harris Edge detection.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class HarrisQuickFilter
	{
		private var _filter:SobelQuickFilter;
		private var _output:BitmapData;

		/**
		 * Creates and returns a string representation of the HarrisQuickFilter object.
		 */
		public function HarrisQuickFilter()
		{
			_filter = new SobelQuickFilter();
		}

		/**
		 * Returns singe Harris points that are found at edges.
		 */
		public function apply( input:BitmapData, points:Vector.<HarrisPoint>, maxNumPoints:int, windowWidth:int = 3, windowHeight:int = 3, skippedPixels:int = 3, minDist:int = 10, minEigenvalue:int = 1 ):void
		{
			// The default params are optimized for performance rather than quality

			// Use a bitmap half the size as given to make it faster.
			// Else there is no chance of getting the job done in a reasonable time

			var mat:Matrix = new Matrix( 0.5, 0, 0, 0.5 );
			_output = new BitmapData( input.width * mat.a, input.height * mat.d, true, 0x0 );
			_output.draw( input, mat, null, null, null, true );
			_filter.applyHVSeparate( _output );
			_output = _filter.output;

			points.splice( 0, points.length );

			var windowHW:uint = windowWidth / 2;
			var windowHH:uint = windowHeight / 2;

			var maxEigenvalue:int = (1 << 16) - 1;
			var eigenvalue:Number;
			var step:int = skippedPixels + 1;

			var height:int = _output.height - windowHH;
			var width:int = _output.width - windowHW;

			// Something I would rather like to see in PixelBender using the output of the SobelFilter
			for( var y:int = windowHH; y < height; y += step )
			{
				for( var x:int = windowHW; x < width; x += step )
				{
					var ghh:Number = 0;
					var ghv:Number = 0;
					var gvv:Number = 0;

					for( var wy:int = y - windowHH; wy <= y + windowHH; wy++ )
					{
						for( var wx:int = x - windowHW; wx <= x + windowHW; wx++ )
						{
							var gh:Number = _filter.getForceH( wx, wy );
							var gv:Number = _filter.getForceV( wx, wy );

							ghh += gh * gh;
							ghv += gh * gv;
							gvv += gv * gv;
						}
					}

					eigenvalue = ( ghh + gvv - Math.sqrt( ( ghh - gvv ) * ( ghh - gvv ) + 4 * ghv * ghv ) ) / 2.0;

					points.push( new HarrisPoint( x, y, Math.min( eigenvalue, maxEigenvalue ) ) );
				}
			}

			// from all acceptable points sort all out that are to close to an already accepted point

			points.sort( function ( a:Object, b:Object ):int
			{
				return a.val < b.val ? +1 : a.val > b.val ? -1 : 0;
			} );

			minDist--;

			var map:BitmapData = new BitmapData( _output.width, _output.height, false, 0x0 );
			var acceptedPoints:int = 0;
			var n:int = points.length;

			for( var i:int = 0; i < n; ++i )
			{
				var p:HarrisPoint = points[i];

				// the map ensures the minimum distance two accepted points must have
				if( p.val >= minEigenvalue && map.getPixel( p.x, p.y ) != 0xFFFFFF )
				{
					// draw a rect around the point. Any other acceptable point will be rejected if its in this rect
					map.fillRect( new Rectangle( p.x - minDist, p.y - minDist, minDist * 2, minDist * 2 ), 0xFFFFFF );

					if( maxNumPoints <= acceptedPoints++ )
					{
						break;
					}
				}
			}

			points.splice( acceptedPoints, points.length - acceptedPoints );
		}

		/**
		 * The filtered image.
		 */
		public function get output():BitmapData
		{
			return _output;
		}

		/**
		 * Creates and returns a string representation of the HarrisQuickFilter object.
		 */
		public function toString():String
		{
			return "[HarrisQuickFilter]";
		}
	}
}