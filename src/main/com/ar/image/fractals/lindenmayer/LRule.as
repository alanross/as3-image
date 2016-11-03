package com.ar.image.fractals.lindenmayer
{
	import com.ar.core.error.ValueError;
	import com.ar.core.log.Context;
	import com.ar.core.log.Log;
	import com.ar.core.utils.ObjectUtils;
	import com.ar.core.utils.StringUtils;

	import flash.utils.Dictionary;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class LRule
	{
		public static const ANTICLOCK:String = "-";
		public static const CLOCKWISE:String = "+";
		public static const PUSH:String = "[";
		public static const POP:String = "]";
		public static const COLOR:String = "C";

		public static const MAX_COMMAND_LENGTH:int = 10000000;

		public var iterations:int;
		public var angle:int;
		public var axiom:String;
		public var constants:Dictionary;
		public var rules:Dictionary;
		public var commands:String;
		public var id:String;
		public var colors:Array;

		public function LRule( id:String, iterations:int, angle:int, constants:String, axiom:String, ruleSets:Array, colors:Array = null )
		{
			if( colors == null || colors.length == 0 )
			{
				colors = [0x0];
			}

			this.id = id;
			this.iterations = iterations;
			this.angle = angle;
			this.constants = createConstantsDictionary( constants );
			this.axiom = axiom;
			this.colors = colors;
			this.rules = createRuleDictionary( ruleSets );
			this.commands = createCommands( iterations, axiom, rules );
		}

		private function createRuleDictionary( ruleSets:Array ):Dictionary
		{
			var dict:Dictionary = new Dictionary();

			for( var i:int = 0; i < ruleSets.length; ++i )
			{
				var rule:String = ruleSets[i];

				if( !StringUtils.isEmpty( rule ) )
				{
					if( rule.length < 2 || rule.charAt( 1 ) != "=" )
					{
						throw new ValueError( "Rule must be of form: F=FX" );
					}

					if( rule.length > 2 )
					{
						dict[ rule.charAt( 0 ) ] = rule.substring( 2 );
					}
				}
			}

			return dict;
		}

		private function createConstantsDictionary( constants:String ):Dictionary
		{
			var dict:Dictionary = new Dictionary();

			if( !StringUtils.isEmpty( constants ) )
			{
				for( var i:int = 0; i < constants.length; i++ )
				{
					var c:String = constants.charAt( i );

					dict[c] = c != ' ' && c != ',';
				}
			}

			return dict;
		}

		private function createCommands( iterations:int, axiom:String, rules:Dictionary ):String
		{
			var result:String = "";

			var tmp:String = axiom;

			for( var i:int = 0; i < iterations; i++ )
			{
				result = "";

				for( var j:int = 0; j < tmp.length; j++ )
				{
					var char:String = tmp.charAt( j );

					var rule:String = rules[char];

					result += ( rule != null ) ? rule : char;

					if( result.length > MAX_COMMAND_LENGTH )
					{
						Log.warn( Context.DEFAULT, this, "Command too long. Aborting." );

						return result;
					}
				}

				tmp = result;
			}

			return result;
		}

		public function getInfo():String
		{
			return "[LRule id:" + id +
					", iterations:" + iterations +
					", angle:" + angle +
					", constants:" + constants +
					", axiom:" + axiom +
					", rules:" + ObjectUtils.objToString( rules ) +
					"]";

		}

		public function toString():String
		{
			return "[LRule id:" + id + "]";
		}
	}
}