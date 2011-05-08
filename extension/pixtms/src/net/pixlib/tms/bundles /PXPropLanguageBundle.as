/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.tms.bundles 
{
	import net.pixlib.encoding.PXDeserializer;
	import net.pixlib.utils.PXObjectUtils;

	/**
	 * The PXPropLanguageBundle class use XLIFF content as bundle content.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXPropLanguageBundle extends PXLanguageBundle
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _deserializer : PXDeserializer; 

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set content( data : Object ) : void
		{
			super.content = _deserializer.deserialize(String(data));
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @param data 			Property file content
		 * @param bundleID		Language bundle ID
		 * 
		 * @langversion 3.0
	 	 * @playerversion Flash 10
		 */
		public function PXPropLanguageBundle(language : String, data : String = null, bundleID : String = ID)
		{
			_deserializer = new INIToObjectDeserializer();
			
			super(language, data ? _deserializer.deserialize(data) : null, bundleID);
			
		}

		/**
		 * @inheritDoc
		 */
		override public function getResource(key : String) : String
		{
			try
			{
				return String(PXObjectUtils.evalFromTarget(content, key));
			}
			catch( e : Error )
			{
			}
			
			return null;
		}
	}
}

import net.pixlib.collections.PXHashMap;
import net.pixlib.core.PXCoreFactory;
import net.pixlib.encoding.PXDeserializer;
import net.pixlib.exceptions.PXIllegalArgumentException;
import net.pixlib.log.PXDebug;

import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * @author Romain Ecarnot
 */
internal class INIToObjectDeserializer implements PXDeserializer
{
	protected var _m : PXHashMap;
		
	public function INIToObjectDeserializer()
	{
		_m = new PXHashMap() ;
			
		addType("Number", getNumber);
		addType("String", getString);
		addType("Array", getArray);
		addType("Boolean", getBoolean);
		addType("Class", getInstance);
		addType("Point", getPoint);
		addType("Rectangle", getRectangle);
	}

	public function deserialize( serializedContent : Object, target : Object = null, key : String = null ) : Object
	{
		var o : Object = new Object();
			
		var lines : Array = serializedContent.toString().split("\n");
		var l : uint = lines.length;
		var pointer : Object = o;
			
		for (var i : uint = 0;i < l; i++ )
		{
			var line : String = lines[ i ];
				
			if( line.length > 3 && line.charAt(0) != ";" )
			{
				if( line.charAt(0) == "[" )
				{
					var section : String = line.substr(1, line.length - 2);
						
					o[ section ] = new Object();
					pointer = o[ section ];
				}
				else
				{
					var propName : String;
					var propType : String = null;
					var pair : Array = line.split("=");
					var pS : String = pair[ 0 ] as String;
					if( pS.indexOf(":") > 0 )
					{
						var def : Array = pS.split(":");
						propName = def[0];
						propType = def[1];
					}
						else propName = pS;
						
					pointer[ propName ] = ( propType != null ) ? _getData(propType, pair[1]) : pair[1] as String;
				}
			}
		}
			
		return o;
	}

	public function addType( type : String, parsingMethod : Function ) : void
	{
		_m.put(type, parsingMethod) ;
	}

	protected static function getArguments( sE : String ) : Array 
	{
		var t : Array = _split(sE);
		var aR : Array = new Array();
		var l : Number = t.length;
			
		for ( var y : uint = 0;y < l; y++ ) 
		{
			var s : String = _stripSpaces(t[y]);
			if (s == 'true' || s == 'false')
			{
				aR.push(s == 'true');
			} 
			else
			{
				if ( s.charCodeAt(0) == 34 || s.charCodeAt(0) == 39 )
				{
					aR.push(s.substr(1, s.length - 2));
				} 
				else
				{
					aR.push(Number(s));
				}
			}
		}
			
		return aR;
	}

	protected function getNumber( str : String ) : Number
	{
		return Number(_stripSpaces(str));
	}

	protected function getString( str : String ) : String
	{
		return str;
	}

	protected function getArray( str : String ) : Array
	{
		return getArguments(str);
	}

	protected function getBoolean( str : String ) : Boolean
	{
		var s : String = _stripSpaces(str);
		return new Boolean(str == "true" || !isNaN(Number(s)) && Number(s) != 0);
	}

	protected function getInstance( str : String ) : Object
	{
		var o : Object;
		var args : Array = getArguments(str);
		var sPackage : String = args[0];
		args.splice(0, 1);
			
		try 
		{
			o = PXCoreFactory.getInstance().buildInstance(sPackage, args);
		} catch ( e : Error )
		{
			var msg : String = this + ".getInstance() failed, can't build class instance specified in xml node [" + sPackage + "]";
			PXDebug.ERROR(msg);
			throw new PXIllegalArgumentException(msg);
		}
			
		return  o;
	}

	protected function getPoint( str : String ) : Point
	{
		var args : Array = getArguments(str);
			
		if ( args[0] == null || args[1] == null )
		{
			var msg : String = this + ".getPoint() failed with values: (" + args[0] + ", " + args[1] + ").";
			PXDebug.ERROR(msg);
			throw new PXIllegalArgumentException(msg);
		}

		return new Point(args[0], args[1]);
	}

	protected function getRectangle( str : String ) : Rectangle
	{
		var args : Array = getArguments(str);
			
		if ( args[0] == null || args[1] == null || args[2] == null || args[3] == null )
		{
			var msg : String = this + ".getRectangle() failed with values: (" + args[0] + ", " + args[1] + args[2] + ", " + args[3] + ").";
			PXDebug.ERROR(msg);
			throw new PXIllegalArgumentException(msg);
		}
			
		return new Rectangle(args[0], args[1], args[2], args[3]);
	}

	private static function _stripSpaces( s : String ) : String 
	{
		var i : Number = 0;
		while( i < s.length && s.charCodeAt(i) == 32 ) i++;
		var j : Number = s.length - 1;
		while( j > -1 && s.charCodeAt(j) == 32 ) j--;
		return s.substr(i, j - i + 1);
	}

	private static function _split( sE : String ) : Array
	{
		var b : Boolean = true;
		var a : Array = new Array();
		var l : Number = sE.length;
		var n : Number;
		var s : String = '';

		for ( var i : Number = 0;i < l; i++ )
		{
			var c : Number = sE.charCodeAt(i);

			if ( b && (c == 34 || c == 39) )
			{
				b = false;
				n = c;
			} 
				else if ( !b && n == c )
			{
				b = true;
				n = undefined;
			}

			if ( c == 44 && b )
			{
				a.push(s);
				s = '';
			} 
			else
			{
				s += sE.substr(i, 1);	
			}
		}

		a.push(s);
		return a;
	}

	private function _getData( type : String, value : String ) : *
	{
		if ( _m.containsKey(type) )
		{
			var d : Function = _m.get(type);
			return d.apply(this, [value]);
		} 
		else
		{
			PXDebug.WARN(type + " type is not supported, returns default string !");
			return value;
		}
	}
}
