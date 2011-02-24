package net.pixlib.utils 
{

	/**
	 * The PXNumberUtils utility class is an all-static class with methods for 
	 * working with Number.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXNumberUtils 
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function format( source : Number, length : uint, char : String = "0", right : Boolean = false ) : String
		{
			var diff : int = length - source.toString().length;
			var rest : String = "";
			
			if( diff > 0 )
			{
				for( var i : uint = 0;i < diff;i++ ) rest += char;
			}
			return ( right ) ? source + rest : rest + source;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function toHex( value : Number, prefix : String = "0x" ) : String
		{
			var s : String = value.toString(16);
			var l : Number = 6 - s.length;
			while (l--) s = "0" + s;
			return prefix + s.toUpperCase();	
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		function PXNumberUtils(  ) 
		{ 	
		}
	}
}
