package com.ar.image.force
{
	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class ForceField implements IForceField
	{
		private static const PI2:Number = Math.PI * 2;

		private var _force:IForce;
		private var _input:BitmapData;
		private var _output:BitmapData;
		private var _particles:ForceParticle;

		private var _width:int = 0;
		private var _height:int = 0;

		/**
		 * Creates a new instance of ForceField.
		 */
		public function ForceField( input:BitmapData, output:BitmapData, force:IForce, numParticles:int = 50000, trailLength:int = 20 )
		{
			_force = force;

			_width = input.width;
			_height = input.height;

			_input = input;
			_output = output;

			var p:ForceParticle;

			var n:int = numParticles;

			p = _particles = new ForceParticle( 1 + Math.random() * trailLength );

			while( --n > -1 )
			{
				p = p.next = new ForceParticle( 1 + Math.random() * trailLength );
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
				++p.age;

				if( p.age > p.life )
				{
					p.x = Math.random() * _width;
					p.y = Math.random() * _height;
					p.color = _input.getPixel32( p.x, p.y );
					p.age = 0;
				}
				else
				{
					var force:Number = bmd.getPixel( p.x, p.y ) / 0xFFFFFF;

					p.speed = force * p.velocity;
					p.angle = force * PI2;

					p.x += Math.cos( p.angle ) * p.speed;
					p.y += Math.sin( p.angle ) * p.speed;

					if( p.x < 0 || p.x > _width || p.y < 0 || p.y > _height )
					{
						p.age = p.life;
					}

					p.paint( _output );
				}

				p = p.next;

			}
			while( p );
		}

		/**
		 * Creates and returns a string representation of the ForceField object.
		 */
		public function toString():String
		{
			return "[PerlinForceField]";
		}
	}
}