package com.ar.image.motion.detection
{
	import com.ar.image.filter.FilterUtils;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class MotionDetector
	{
		private static const zero:Point = new Point();
		private static const preBlur:ConvolutionFilter = FilterUtils.mean();
		private static const postBlur:BlurFilter = new BlurFilter( 4, 4, 1 );

		/**
		 * Finds pixel regions that differ between both provided images.
		 */
		public static function findChangeRegions( bmdCurrent:BitmapData, bmdNext:BitmapData, diff:BitmapData ):void
		{
			const orig:BitmapData = bmdCurrent.clone();
			const next:BitmapData = bmdNext.clone();

			// reduce input noise by blurring
			//orig.applyFilter( orig, orig.rect, zero, preBlur );
			//next.applyFilter( next, next.rect, zero, preBlur );

			// the difference between both bitmaps, no difference is black, difference is any color
			diff.copyPixels( orig, orig.rect, zero );
			diff.draw( next, null, null, BlendMode.DIFFERENCE );

			// reduce difference noise by blurring
			diff.applyFilter( diff, diff.rect, zero, postBlur );

			// change any color to white, if its lighter than dark grey
			diff.threshold( diff, diff.rect, zero, ">", 0xFF111111, 0xFFFFFFFF, 0xFFFFFFFF, false );

			// change any color other than white, to transparent
			diff.threshold( diff, diff.rect, zero, "<", 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, false );
		}

		/**
		 * Returns a rectangle encompassing all found pixe change regions
		 */
		public static function getChangeRect( bmdOrig:BitmapData, bmdDiff:BitmapData, motionBmd:BitmapData, motionRect:Rectangle ):Point
		{
			findChangeRegions( bmdOrig, bmdDiff, motionBmd );

			const b:Rectangle = motionBmd.getColorBoundsRect( 0xFFFFFFFF, 0xFFFFFFFF, true );
			motionRect.x = b.x;
			motionRect.y = b.y;
			motionRect.width = b.width;
			motionRect.height = b.height;

			const movementCenter:Point = new Point( -1, -1 );

			if( b.width != 0 )
			{
				movementCenter.x = ( b.x + ( b.x + b.width ) ) * 0.5;
				movementCenter.y = ( b.y + ( b.y + b.height ) ) * 0.5
			}

			return movementCenter;
		}

		/**
		 * Creates a new instance of MotionDetector.
		 */
		public function MotionDetector()
		{
			throw new Error( "MotionDetector class is static container only." );
		}

		/**
		 * Generates and returns the string representation of the MotionDetector object.
		 */
		public function toString():String
		{
			return "[MotionDetector]";
		}
	}
}