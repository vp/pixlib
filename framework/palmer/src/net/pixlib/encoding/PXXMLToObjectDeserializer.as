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
package net.pixlib.encoding
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.log.PXDebug;
	import net.pixlib.structures.PXDimension;
	import net.pixlib.structures.PXRange;

	import flash.geom.Point;

	/**
	 * The PXXMLToObjectDeserializer class deserialize xml content to build 
	 * Object instance using XML definition.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXXMLToObjectDeserializer implements PXDeserializer
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		protected var mMap : PXHashMap;		protected var oFactory : PXCoreFactory;
		protected var bDeserializeAttributes : Boolean;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------

		public var pushInArray : Boolean;
		
		static public var DEBUG_IDENTICAL_NODE_NAMES : Boolean = false;
		static public var PUSHINARRAY_IDENTICAL_NODE_NAMES : Boolean = true;
		static public var ATTRIBUTE_TARGETED_PROPERTY_NAME : String = null;
		static public var DESERIALIZE_ATTRIBUTES : Boolean = false;

		/**
		 * Indicates if XML attributes must be deserialized.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get deserializeAttributes() : Boolean
		{
			return bDeserializeAttributes;
		}
		/**
		 * @private
		 */
		public function set deserializeAttributes( b : Boolean ) : void
		{
			if (b != bDeserializeAttributes)
			{
				if ( b )
				{
					addType("", getObjectWithAttributes);
				} 
				else
				{
					addType("", getObject);
				}
			}
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Creates instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXXMLToObjectDeserializer()
		{
			oFactory = PXCoreFactory.getInstance();
			mMap = new PXHashMap() ;
			
			addType("Number", getNumber);
			addType("String", getString);
			addType("Array", getArray);
			addType("Boolean", getBoolean);
			addType("Class", getInstance);
			addType("Point", getPoint);
			addType("Dimension", getDimension);
			addType("Range", getRange);
			addType("", getObject);
			
			pushInArray = PXXMLToObjectDeserializer.PUSHINARRAY_IDENTICAL_NODE_NAMES;
			deserializeAttributes = PXXMLToObjectDeserializer.DESERIALIZE_ATTRIBUTES;
		}
		
		/**
		 * Deserializes passed-in serializedContent and returns an Object instance 
		 * using deserialization result.
		 * 
		 * @param serializedContent Content to deserialize (XML or String source)
		 * @param target			(optional) Object to store deserialization 
		 * 							result.
		 * @param key				(optional) Registration identifier
		 * 
		 * @return serializedContent as an Object instance if deserialization 
		 * process is success.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function deserialize( serializedContent : Object, target : Object = null, key : String = null ) : Object
		{
			if ( target == null ) target = {};
			
			var xml : XML;
			if( serializedContent is String )
			{
				xml = new XML(serializedContent as String);
			}
			else xml = serializedContent as XML;
			
			for each ( var property : XML in xml.* ) deserializeNode(target, property) ;
			return target ;
		}
		
		/**
		 * Add new type to deserialize.
		 * 
		 * @param type	Type to check
		 * @param parsingMethod	Method to use to deserialize this type
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addType( type : String, parsingMethod : Function ) : void
		{
			mMap.put(type, parsingMethod) ;
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Deserializes passed-in XML node using target object to store result.
		 * 
		 * @param target	Object to use to store deserialization result
		 * @param node		XML definition to deserialize
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function deserializeNode( target : Object, node : XML ) : Object
		{
			var member : String = node.name().toString();
			var obj : Object = {};
			
			if (node.attribute("type").length() == 0 && !node.hasSimpleContent())
			{
				obj = _getData(node);
			}
			else
			{
				obj["value"] = _getData(node) ;
			}
				
			obj["attribute"] = {};
			for ( var i : int = 0 ;i < node.attributes().length() ;i++ )
			{
				var nom : String = String(node.attributes()[i].name());
				obj["attribute"][nom] = node.attributes()[i];
			}
			
			if ( target[member] ) 
			{
				target[member] = getNodeContainer(target, member);
				target[member].push(obj) ;
			} 
			else
			{
				target[member] = obj ;
			}

			return target ;
		}


		//--------------------------------------------------------------------
		// Private methods
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function _getData( node : XML ) : *
		{
			var dataType : String = node.attribute("type");
			
			if ( mMap.containsKey(dataType) )
			{
				var method : Function = mMap.get(dataType);
				return method.apply(this, [node]);
			} 
			else
			{
				PXDebug.WARN(dataType + " type is not supported!", this);
				return null;
			}
		}

		/**
		 * @private
		 */
		protected static function getNodeContainer( target : *, member : String ) : Array
		{
			var temp : Object = target[ member ];

			if(temp.__nodeContainer)
			{
				return target[ member ] as Array;
			} 
			else
			{
				var arr : Array = new Array();
				arr[ "__nodeContainer" ] = true;
				arr.setPropertyIsEnumerable("__nodeContainer", false);
				arr.push(temp);
				return arr;
			}
		}
		
		/**
		 * @private
		 */
		protected static function getArguments(arguments : String) : Array 
		{
			var args : Array = split(arguments);
			var array : Array = new Array();
			var length : Number = args.length;
			
			for ( var y : int = 0;y < length;y++ ) 
			{
				var src : String = stripSpaces(args[y]);
				if (src == 'true' || src == 'false')
				{
					array.push(src == 'true');
				} 
				else
				{
					if ( src.charCodeAt(0) == 34 || src.charCodeAt(0) == 39 )
					{
						array.push(src.substr(1, src.length - 2));
					} 
					else
					{
						array.push(Number(src));
					}
				}
			}
			
			return array;
		}
		
		/**
		 * @private
		 */
		protected function getNumber( node : XML ) : Number
		{
			return Number(PXXMLToObjectDeserializer.stripSpaces(node));
		}

		/**
		 * @private
		 */
		protected function getString( node : XML ) : String
		{
			return node;
		}
		
		/**
		 * @private
		 */
		protected function getArray( node : XML ) : Array
		{
			return getArguments(node);
		}
		
		/**
		 * @private
		 */
		protected function getBoolean( node : XML ) : Boolean
		{
			var src : String = PXXMLToObjectDeserializer.stripSpaces(node);
			return new Boolean(src == "true" || !isNaN(Number(src)) && Number(src) != 0);
		}
		
		/**
		 * @private
		 */
		protected function getObject( node : XML ) : Object
		{
			var data : XML = node;	  		
			return data.hasSimpleContent() ? data : deserialize(node, {});
		}

		/**
		 * @private
		 */
		protected function getInstance( node : XML ) : Object
		{
			var obj : Object;
			var args : Array = getArguments(node);
			var sPackage : String = args[0]; 
			args.splice(0, 1);

			try 
			{
				obj = oFactory.buildInstance(sPackage, args);
			} catch ( e : Error )
			{
				throw new PXIllegalArgumentException(".getInstance() failed, can't build class instance specified in xml node [" + sPackage + "]", this);
			}

			return  obj;
		}

		/**
		 * @private
		 */
		protected function getPoint( node : XML ) : Point
		{
			var args : Array = getArguments(node);

			if ( args[0] == null || args[1] == null )
			{
				throw new PXIllegalArgumentException(".getPoint() failed with values: (" + args[0] + ", " + args[1] + ").", this);
			}

			return new Point(args[0], args[1]);
		}
		
		/**
		 * @private
		 */
		protected function getDimension( node : XML ) : PXDimension
		{
			var args : Array = getArguments(node);
	  		
			if ( args[0] == null || args[1] == null )
			{
				throw new PXIllegalArgumentException(".getDimension() failed with values: (" + args[0] + ", " + args[1] + ").", this);
			}
	  		
			return new PXDimension(args[0], args[1]);
		}

		/**
		 * @private
		 */
		protected function getRange( node : XML ) : PXRange
		{
			var args : Array = getArguments(node);
	  		
			if ( args[0] == null || args[1] == null )
			{
				throw new PXIllegalArgumentException(".getRange() failed with values: (" + args[0] + ", " + args[1] + ").", this);
			}
	  		
			return new PXRange(args[0], args[1]);
		}
		
		/**
		 * @private
		 */
		protected function getObjectWithAttributes( node : XML ) : Object
		{
			var data : XML = node;
			var obj : Object = new Object();
			var attribTarget : Object;

			var src : String = PXXMLToObjectDeserializer.ATTRIBUTE_TARGETED_PROPERTY_NAME;
			if ( src.length > 0 ) attribTarget = obj[src] = new Object();

			for ( var p : String in node.attributes() ) 
			{
				if ( !(mMap.containsKey(p)) ) 
				{
					if ( attribTarget )
					{
						attribTarget[p] = node.attributes[p];
					} 
					else
					{
						obj[p] = node.attributes[p];
					}
				}
			}

			return data ? data : deserialize(node, obj);
		}
		
		/**
		 * @private
		 */
		static protected function stripSpaces( s : String ) : String 
		{
			var index : Number = 0;
			while( index < s.length && s.charCodeAt(index) == 32 ) index++;
			var cpt : Number = s.length - 1;
			while( cpt > -1 && s.charCodeAt(cpt) == 32 ) cpt--;
			return s.substr(index, cpt - index + 1);
		}
		
		/**
		 * @private
		 */
		static protected function split( sE : String ) : Array
		{
			var bool : Boolean = true;
			var args : Array = new Array();
			var length : Number = sE.length;
			var num : Number;
			var src : String = "";

			for ( var i : Number = 0;i < length;i++ )
			{
				var char : Number = sE.charCodeAt(i);

				if ( bool && (char == 34 || char == 39) )
				{
					bool = false;
					num = char;
				} else if ( !bool && num == char )
				{
					bool = true;
					num = undefined;
				}

				if ( char == 44 && bool )
				{
					args.push(src);
					src = '';
				} 
				else
				{
					src += sE.substr(i, 1);	
				}
			}

			args.push(src);
			return args;
		}
		
	}
}