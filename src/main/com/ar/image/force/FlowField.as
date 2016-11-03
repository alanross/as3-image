package com.ar.image.force
{
	import com.ar.image.utils.BitmapUtils;
	import com.ar.math.Maths;

	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class FlowField implements IForceField
	{
		private static const PI2:Number = Math.PI * 2;

		private var _input:BitmapData;
		private var _output:BitmapData;
		private var _force:IForce;
		private var _particles:ForceParticle;

		private var _length:int;
		private var _color:int;

		/**
		 * Creates a new instance of FlowField.
		 */
		public function FlowField( input:BitmapData, output:BitmapData, force:IForce, length:int = 4, color:int = 0xFFFFFFFF )
		{
			_force = force;
			_length = length;
			_color = color;

			_input = input;
			_output = output;

			var layout:Vector.<Point> = Maths.grid2( input.width, input.height, 10, 10 );
			var pos:Point;

			var p:ForceParticle;
			p = _particles = new ForceParticle( 1 );

			const n:int = layout.length;

			for( var i:int = 0; i < n; ++i )
			{
				pos = layout[i];

				p = p.next = new ForceParticle( 1 );
				p.x = pos.x;
				p.y = pos.y;
				p.age = p.life;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function update():void
		{
			_force.update();

			var bmd:BitmapData = _force.bitmapData;
			var p:ForceParticle = _particles.next;

			do
			{
				// angle in radian
				var a:Number = ( bmd.getPixel( p.x, p.y ) / 0xFFFFFF ) * PI2;

				BitmapUtils.drawLine( _output, p.x, p.y, p.x + Math.cos( a ) * _length, p.y + Math.sin( a ) * _length, _color );

				p = p.next;

			}
			while( p );
		}

		/**
		 * Creates and returns a string representation of the FlowField object.
		 */
		public function toString():String
		{
			return "[FlowField]";
		}
	}
}