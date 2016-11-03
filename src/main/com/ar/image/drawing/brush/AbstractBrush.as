package com.ar.image.drawing.brush
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class AbstractBrush implements IBrush
	{
		protected var canvas:BitmapData;
		protected var brushX: int = 0;
		protected var brushY: int = 0;

		/**
		 * Creates a new instance of AbstractBrush.
		 */
		public function AbstractBrush()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function bind( bmd:BitmapData ):void
		{
			canvas = bmd;
		}

		/**
		 * @inheritDoc
		 */
		public function unbind( bmd:BitmapData ):void
		{
			canvas = null;
		}

		/**
		 * @inheritDoc
		 */
		public function beginStroke( posX:int, posY:int ):void
		{
			brushX = posX;
			brushY = posY;
		}

		/**
		 * @inheritDoc
		 */
		public function updateStroke( posX:int, posY:int ):void
		{
			brushX = posX;
			brushY = posY;
		}

		/**
		 * @inheritDoc
		 */
		public function endStroke( posX:int, posY:int ):void
		{
			brushX = posX;
			brushY = posY;
		}

		/**
		 * Creates and returns a string representation of the AbstractBrush object.
		 */
		public function toString():String
		{
			return "[AbstractBrush]";
		}
	}
}