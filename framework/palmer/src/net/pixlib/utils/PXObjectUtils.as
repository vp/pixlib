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
package net.pixlib.utils
{
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;

	import flash.display.DisplayObject;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * The PXObjectUtils utility class is an all-static class with methods for 
	 * working with objects.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Francis Bourre
	 * @author	Cédric Néhémie
	 */
	final public class PXObjectUtils
	{
		/**
		 * Clone an object
		 * 
		 * @param   source	Object to clone
		 * @return  Object  Object cloned
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function clone( source : Object ) : Object 
		{
			if( source === null ) return null;
			if ( source is DisplayObject ) 
			{
				var msg : String = "ObjectUtils.clone(" + source + ") failed. This method can't work with a DisplayObject argument";
				PXDebug.ERROR(msg, PXObjectUtils);
				throw new PXIllegalArgumentException(msg);
			}

			if ( source.hasOwnProperty("clone") && source.clone is Function ) return source.clone();
			if ( source is Array ) return PXObjectUtils.cloneArray(source as Array) ;

			var qualifiedClassName : String = getQualifiedClassName(source);
			var aliasName : String = qualifiedClassName.split("::")[1];
			
			if ( aliasName ) registerClassAlias(aliasName, (getDefinitionByName(qualifiedClassName) as Class));
			
			var bytes : ByteArray = new ByteArray();
			bytes.writeObject(source);
			bytes.position = 0;
			
			return( bytes.readObject() );
		}

		/**
		 * Clone array's content
		 * 
		 * @param   a	Array to clone
		 * @return  a   Array cloned
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function cloneArray( source : Array ) : Array
		{
			var newArray : Array = new Array();

			for each( var o : Object in source )
			{
				if ( o is Array )
					newArray.push(PXObjectUtils.cloneArray(o as Array));
				else
				{
					if( o.hasOwnProperty("clone") && o.clone is Function )
						newArray.push(o.clone()) ;
					else
						newArray.push(PXObjectUtils.clone(o));
				}
			}
			
			return newArray;
		}

		/**
		 * <p>Allow access to a value like dot syntax in as2</p>
		 * 
		 * <b>sample:</b>
		 * <p>
		 * var btnLaunch : DisplayObject = evalFromTarget( this , "mcHeader.btnLaunch") as DisplayObject;
		 * </p>
		 * 
		 * @param   target the root path of the first element write in the string <p>in the example mcHeader is a child of this</p>
		 * @param   toEval the path of the element to retrieve
		 * @return  null if object not found , else the object pointed by <b>toEval</b>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function evalFromTarget( target : Object, toEval : String ) : Object 
		{
			var chars : Array = toEval.split("");
			if( toEval.indexOf("(") > -1 )
			{
				var tL : uint = chars.length;
				var cpt : uint = 0;
				for(var c : uint = 0;c < tL;c++)
				{
					if(chars[c] == "(") cpt++;
					if(chars[c] == "." && cpt > 0) chars[c] = "{" + cpt + "}";
					if(chars[c] == ")") cpt--;
				}
			}
			toEval = chars.join("");
			
			var arr : Array = toEval.split(".");
			var length : int = arr.length;
			var msg : String;
			
			for ( var i : int = 0;i < length;i++ )
			{
				var prop : String = arr[ i ];
				
				var args : Array = [];
				var propName : String = prop;
				var bMethod : Boolean = false;
				
				if(prop.indexOf("(") > -1 )
				{
					var sA : String = PXStringUtils.trim(prop.substring(prop.indexOf("(") + 1, prop.lastIndexOf(")")));
					args = sA.length > 1 ? sA.indexOf(",") > -1 ? sA.split(",") : [sA] : [];
					propName = prop.substring(0, prop.indexOf("("));
					bMethod = true;
				}
				
				if ( target.hasOwnProperty(propName) )
				{
					var tmp : * = target[propName];
					target = tmp;
					
					if(bMethod && tmp is Function)
					{
						var array : Array = new Array();
						var aLength : Number = args.length;
			
						for ( var y : int = 0;y < aLength;y++ ) 
						{
							var src : String = PXStringUtils.trim(unescape(args[y]));
							
							for(var cycle : uint = 0;cycle <= 20;cycle++ )
							{
								src = src.replace("{" + cycle + "}", ".");	
							}
							
							var key : String = src;
							if ( key.indexOf(".") != -1 ) key = String((key.split(".")).shift());
							
							if (src == "true" || src == "false")
							{
								array.push(src == "true");
							} 
							else if ( src.charCodeAt(0) == 34 || src.charCodeAt(0) == 39 )
							{
								array.push(src.substr(1, src.length - 2));
							} 
							else if ( src.charCodeAt(0) == 60 )
							{
								array.push(new XML(src.substr(1, src.length - 2)));
							}
							else if( PXCoreFactory.getInstance().isRegistered(key))
							{
								var pT : Object = PXCoreFactory.getInstance().locate(key);
								
								if(src.indexOf(".") > -1 )
								{
									var chain : Array = src.split(".");
									chain.shift();
									array.push(evalFromTarget(pT, chain.join(".")));
								}
								else array.push(pT);
							}
							else if(!isNaN(Number(src)))
							{
								array.push(Number(src));	
							}
							else 
							{
								array.push(src);
							}
						}
						
						try
						{
							target = tmp.apply(null, array);
						}
						catch(e : Error)
						{
							msg = "ObjectUtils.evalFromTarget(" + target + ", " + toEval + ") failed.Inline method failed : " + prop + " on " + PXStringifier.process(target);
						}
					}
				} 
				else
				{
					throw new PXNoSuchElementException("ObjectUtils.evalFromTarget(" + target + ", " + toEval + ") failed.", PXObjectUtils);
				}
			}

			return target;
		}

		/**
		 * Returns <code>true</code> if the passed-in <code>source</code> object 
		 * reference specified is a simple data type.
		 *  
		 * <p>Simple data types include :
		 * <ul>
		 *    <li><code>String</code></li>
		 *    <li><code>Number</code></li>
		 *    <li><code>uint</code></li>
		 *    <li><code>int</code></li>
		 *    <li><code>Boolean</code></li>
		 *    <li><code>Date</code></li>
		 *    <li><code>Array</code></li>
		 * </ul></p>
		 *
		 * @param source Object inspected.
		 *
		 * @return <code>true</code> if the object is a simple data type
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function isSimple( source : Object ) : Boolean
		{
			switch ( typeof( source ) )
			{
				case "number":
				case "string":
				case "boolean":
					return true;
				case "object":
					return (source is Date) || (source is Array);
			}
			
			return false;
		}
		
		/**
		 * @private
		 */
		function PXObjectUtils( )
		{
		}
	}
}