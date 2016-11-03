package com.ar.image.contour
{
	import com.ar.core.log.Context;
	import com.ar.core.log.Log;

	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class MarchingSquaresContour
	{
		private static const MAX_POINTS = 10000;

		private static const DIRECTIONS:Object = {
			"0011" : new ContourPoint( 1, 0 ),
			"1011" : new ContourPoint( 1, 0 ),
			"0001" : new ContourPoint( 1, 0 ),
			"1001" : new ContourPoint( 1, 0 ),

			"0100" : new ContourPoint( 0, -1 ),
			"0101" : new ContourPoint( 0, -1 ),
			"0111" : new ContourPoint( 0, -1 ),
			"0110" : new ContourPoint( 0, -1 ),

			"1100" : new ContourPoint( -1, 0 ),
			"1000" : new ContourPoint( -1, 0 ),
			"1101" : new ContourPoint( -1, 0 ),

			"1110" : new ContourPoint( 0, 1 ),
			"1010" : new ContourPoint( 0, 1 ),
			"0010" : new ContourPoint( 0, 1 )
		};

		public function MarchingSquaresContour()
		{
		}

		public function traceOutline( bitmapData: BitmapData ): Vector.<ContourPoint>
		{
			var result:Vector.<ContourPoint> = new Vector.<ContourPoint>();

			var posInitial:ContourPoint = getInitialPosition( bitmapData );

			if( posInitial == null  )
			{
				return result;
			}

			// in order for the lookup to work, we move the position up and back one
			posInitial.x -= 1;
			posInitial.y -= 1;

			var posCurrent:ContourPoint = posInitial;
			var posNext:ContourPoint;
			var posCase:String;

			var dict:Dictionary = new Dictionary();

			for( var i:int = 1; i < MAX_POINTS; ++i )
			{
				var id:String = posCurrent.x + ":" + posCurrent.y;

				if( dict[id] == null )
				{
					dict[id] = true;
					result.push( posCurrent );
				}
				else
				{
					Log.warn( Context.DEFAULT, this, "DOUPLICATE" );
				}

				posCase = getDirection( bitmapData, posCurrent );

				posNext = getNextEdgePosition( posCurrent, posCase );

				if( posNext.equals( posInitial ) )
				{
					return result;
				}

				posCurrent = posNext;
			}

			Log.warn( Context.DEFAULT, this, "MAX_POINTS reached" );

			return new Vector.<ContourPoint>();
		}

		public function getInitialPosition( bitmapData:BitmapData )
		{
			for( var y:int = 0; y < bitmapData.height; ++y )
			{
				for( var x:int = 0; x < bitmapData.width; ++x )
				{
					if( bitmapData.getPixel32( x, y ) > 0 )
					{
						return new ContourPoint( x, y );
					}
				}
			}

			return null;
		}

		public function getNextEdgePosition( p:ContourPoint, direction:String ):ContourPoint
		{
			var offset:ContourPoint = DIRECTIONS[direction];

			if( p == null )
			{
				throw new Error( "MarchingSquares Error : gridString:" + direction + " , not found in possibleGrids" );
			}

			return new ContourPoint( p.x + offset.x, p.y + offset.y );
		}

		public function getDirection( bitmapData:BitmapData, p:ContourPoint ):String
		{
			var direction:String = "";

			direction += bitmapData.getPixel32( p.x, p.y ) ? "1" : "0";
			direction += bitmapData.getPixel32( p.x + 1, p.y ) ? "1" : "0";
			direction += bitmapData.getPixel32( p.x, p.y + 1 ) ? "1" : "0";
			direction += bitmapData.getPixel32( p.x + 1, p.y + 1 ) ? "1" : "0";

			return direction;
		}

		public function toString():String
		{
			return "[MarchingSquaresContour]";
		}
	}
}