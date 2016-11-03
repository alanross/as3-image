package com.ar.image.drawing.brush.particle
{
	import com.ar.image.drawing.brush.*;
	import com.ar.core.error.AbstractFunctionError;

	import flash.display.BitmapData;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class ParticleBrush extends AbstractBrush
	{
		protected var stroke:Boolean = false;

		// Access to EnterFrame event
		private var _dispatcher:Sprite;

		/**
		 * Creates a new instance of ParticleBrush.
		 */
		public function ParticleBrush()
		{
			_dispatcher = new Sprite();
		}

		/**
		 * @inheritDoc
		 */
		override public function bind( bmd:BitmapData ):void
		{
			super.bind( bmd );

			_dispatcher.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}

		/**
		 * @inheritDoc
		 */
		override public function unbind( bmd:BitmapData ):void
		{
			_dispatcher.removeEventListener( Event.ENTER_FRAME, onEnterFrame );

			super.unbind( bmd );
		}

		/**
		 * @inheritDoc
		 */
		override public function beginStroke( posX:int, posY:int ):void
		{
			brushX = posX;
			brushY = posY;

			stroke = true;
		}

		/**
		 * @inheritDoc
		 */
		override public function updateStroke( posX:int, posY:int ):void
		{
			brushX = posX;
			brushY = posY;
		}

		/**
		 * @inheritDoc
		 */
		override public function endStroke( posX:int, posY:int ):void
		{
			stroke = false;
		}

		/**
		 * @private
		 */
		private function onEnterFrame( event:Event ):void
		{
			draw( brushX, brushY, stroke );
		}

		/**
		 * To be overwritten by subclass. Called on each render tick to update painting.
		 */
		protected function draw( posX:int, posY:int, stroke:Boolean ):void
		{
			throw new AbstractFunctionError();
		}

		/**
		 * Creates and returns a string representation of the ParticleBrush object.
		 */
		override public function toString():String
		{
			return "[ParticleBrush]";
		}
	}
}