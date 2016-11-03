package com.ar.image.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class BitmapUtils
	{
		/**
		 * Draw given DisplayObject to BitmapData
		 */
		public static function capture( d:DisplayObject ):BitmapData
		{
			var bounds:Rectangle = d.getBounds( d );
			var bitmap:BitmapData = new BitmapData( int( bounds.width + 0.5 ), int( bounds.height + 0.5 ), true, 0 );
			bitmap.draw( d, new Matrix( 1, 0, 0, 1, -bounds.x, -bounds.y ) );
			return bitmap;
		}

		/**
		 * Keeps pixels that are brighter than threshold
		 */
		public static function keepBrighter( bmd:BitmapData, darkest:uint = 0xFF888888 ):void
		{
			var c:uint = 0xFFFF0000;	// color of pixels that are kept.
			var m:uint = 0xFFFFFFFF;	// mask

			bmd.threshold( bmd, bmd.rect, bmd.rect.topLeft, "<=", darkest, c, m, false );
		}

		/**
		 * Keeps pixels that are darkerthan threshold
		 */
		public static function keepDarker( bmd:BitmapData, lightest:uint = 0xFF888888 ):void
		{
			var c:uint = 0xFFFF0000;	// color of pixels that are kept.
			var m:uint = 0xFFFFFFFF;	// mask

			bmd.threshold( bmd, bmd.rect, bmd.rect.topLeft, ">=", lightest, c, m, false );
		}

		/**
		 * Draws a pixel line between two given points.
		 */
		public static function drawLine( bmd:BitmapData, x0:int, y0:int, x1:int, y1:int, color:int ):void
		{
			// Simplified version of Bresenham's line algorithm.
			// http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm

			var dx:Number = Math.abs( x1 - x0 );
			var dy:Number = Math.abs( y1 - y0 );

			var sx:Number = ( x0 < x1 ) ? 1 : -1;
			var sy:Number = ( y0 < y1 ) ? 1 : -1;

			var err:Number = dx - dy;

			while( true )
			{
				bmd.setPixel32( x0, y0, color );

				if( x0 == x1 && y0 == y1 )
				{
					return;
				}

				var e2:Number = 2 * err;

				if( e2 > -dy )
				{
					err = err - dy;
					x0 = x0 + sx;
				}
				if( x0 == x1 && y0 == y1 )
				{
					bmd.setPixel32( x0, y0, color );
					return;
				}

				if( e2 < dx )
				{
					err = err + dx;
					y0 = y0 + sy;
				}
			}
		}

		/**
		 * Creates a new instance of BitmapUtils.
		 */
		public function BitmapUtils()
		{
			throw new Error( "BitmapUtils class is static container only." );
		}

		/**
		 * Generates and returns the string representation of the BitmapUtils object.
		 */
		public function toString():String
		{
			return "[BitmapUtils]";
		}
	}
}