package com.ar.image.drawing.brush.smooth
{
	import com.ar.image.drawing.brush.*;
	import com.ar.core.error.AbstractFunctionError;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class AbstractSmoothBrush extends AbstractBrush
	{
		/**
		 * Creates a new instance of AbstractSmoothBrush.
		 */
		public function AbstractSmoothBrush()
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function beginStroke( posX:int, posY:int ):void
		{
			super.beginStroke( posX, posY );

			draw( posX, posY );
		}

		/**
		 * @inheritDoc
		 */
		override public function updateStroke( posX:int, posY:int ):void
		{
			if( brushX != posX || brushY != posY )
			{
				interpolate( posX, posY );
			}
		}

		/**
		 * @private
		 */
		private function interpolate( posX:int, posY:int ):void
		{
			var dx:int = posX - brushX;
			var dy:int = posY - brushY;

			const incX:int = ( dx > 0 ) ? 1 : ( dx == 0 ) ? 0 : -1;
			const incY:int = ( dy > 0 ) ? 1 : ( dy == 0 ) ? 0 : -1;

			var tmpX:int = brushX;
			var tmpY:int = brushY;

			var errorX:int = 0;
			var errorY:int = 0;

			dx = Math.abs( dx );
			dy = Math.abs( dy );

			const dist:int = ( dx > dy ) ? dx : dy;

			const n:int = dist + 1;

			for( var i:int = 0; i <= n; ++i )
			{
				draw( tmpX, tmpY );

				errorX += dx;
				errorY += dy;

				if( errorX > dist )
				{
					errorX -= dist;
					tmpX += incX;
				}
				if( errorY > dist )
				{
					errorY -= dist;
					tmpY += incY;
				}
			}

			brushX = posX;
			brushY = posY;
		}

		/**
		 * @inheritDoc
		 */
		protected function draw( posX:int, posY:int ):void
		{
			throw new AbstractFunctionError();
		}

		/**
		 * Creates and returns a string representation of the AbstractSmoothBrush object.
		 */
		override public function toString():String
		{
			return "[AbstractSmoothBrush]";
		}
	}
}