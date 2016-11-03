package com.ar.image.fractals.lindenmayer
{
	import com.ar.math.Maths;
	import com.ar.math.Scale;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class LSystem
	{
		public function LSystem()
		{
		}

		public function render( output:BitmapData, rule:LRule, stepDistance:int = 5, maxStackDepth:int = 5 ):void
		{
			var canvas:Shape = new Shape();

			var commands:String = rule.commands;

			var stack:Array = [];
			var turtle:LTurtle = new LTurtle( 0, 0, -90, 0, -1 );

			for( var j:int = 0; j < commands.length; j++ )
			{
				var cmd:String = commands.charAt( j );

				switch( cmd )
				{
					case LRule.COLOR:
						// colour index from next command char
						turtle.color = rule.colors[ parseInt( commands.charAt( ++j ) ) ];
						break;
					case LRule.ANTICLOCK:
						turtle.angle += rule.angle;
						break;
					case LRule.CLOCKWISE:
						turtle.angle -= rule.angle;
						break;
					case LRule.PUSH:
						turtle.level = stack.length + 1;
						stack.push( turtle.clone() );
						break;
					case LRule.POP:
						turtle = stack.pop();
						break;
					default:
						if( !rule.constants[cmd] )
						{
							var level:Number = Maths.clamp( turtle.level / maxStackDepth, 0.0, 1.0 );
							var angle:Number = Maths.deg2rad( turtle.angle );

							var size:Number = ( 1.0 - level ) * 1.5;
							var color:int = turtle.color;

							if( color == -1 )
							{
								color = rule.colors[ int( level * maxStackDepth ) ];
							}

							canvas.graphics.moveTo( turtle.x, turtle.y );

							turtle.x += Math.cos( angle ) * stepDistance;
							turtle.y += Math.sin( angle ) * stepDistance;

							canvas.graphics.lineStyle( size, color );
							canvas.graphics.lineTo( turtle.x, turtle.y );
						}
						break;
				}
			}

			var bounds:Rectangle = canvas.getRect( canvas );

			var s:Point = Scale.getScale( bounds.width, bounds.height, output.width, output.height, Scale.TYPE_FIT );

			var ox:int = -bounds.x * s.x + ( (output.width - bounds.width * s.x) * 0.5);
			var oy:int = -bounds.y * s.y;

			output.draw( canvas, new Matrix( s.x, 0, 0, s.y, ox, oy ) );
		}

		public function toString():String
		{
			return "[LSystem]";
		}
	}
}