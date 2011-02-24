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
package net.pixlib.core
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * A factory for object creation.
	 * 
	 * <p>The <code>PXCoreFactory</code> can build any object of any type. 
	 * The <code>PXCoreFactory</code> is intensively used in the IoC assembler.
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Francis Bourre
	 */
	final public class PXCoreFactory
	{
		/**
		 * Builds an instance of the passed-in class with the specified arguments
		 * passed to the class constructor. The function can also work with singleton
		 * factory and factory methods.
		 * <p>
		 * When trying to create an object, the function will work as below :
		 * </p><ol>
		 * <li>The function try to retreive a reference to te specified class, if
		 * the class cannot be found in the current application domain the function
		 * will fail with an exception.</li>
		 * <li>Then the function will look to a factory method, if one have been
		 * specified, if the <code>singletonAccess</code> is also specified, the
		 * function retreive a reference to the singleton instance and then call
		 * the factory method on it. If there is no singleton access, the function
		 * call the factory method directly on the class.</li>
		 * <li>If <code>singletonAccess</code> is specified and <code>factoryMethod</code>
		 * parameter is null, this method will try to return an instance using singleton
		 * access parameter as static method name of the class passed.</li>
		 * <li>If there is neither a factory method nor a singleton accessor, the
		 * function will instantiate the class using its constructor.</li>
		 * </ol><p>
		 * In AS3, the <code>constructor</code> property of a class is not a function
		 * but an object, resulting that it is not possible to use the <code>apply</code>
		 * or <code>call</code> method on the constructor of a class. The workaround
		 * we use is to create wrapping methods which correspond each to a specific call
		 * to a class constructor with a specific number of arguments, in that way, we can
		 * select the right method to use according to the number of arguments specified
		 * in the <code>buildInstance</code> call. However, there's a limitation, we decided
		 * to limit the number of arguments to <code>30</code> values.
		 * </p>
		 * 
		 * @param	qualifiedClassName	the full classname of the class to create as returned
		 * 								by the <code>getQualifiedClassName</code> function
		 * @param	args				array of arguments to transmit into the constructor
		 * @param	factoryMethod		the name of a factory method provided by the class
		 * 								to use in place of the constructor
		 * @param	singletonAccess		the name of the singleton accessor method if the
		 * 								factory method is a member of the singleton instance
		 * @return	an instance of the specified class, or <code>null</code>
		 * @throws 	Error — The specified classname cannot be found
		 * 			in the current application domain 
		 * 			
		 * @example Creating a <code>Point</code> instance using the <code>PXCoreFactory</code> class : 
		 * <listing>PXCoreFactory.buildInstance( "flash.geom::Point", [ 50, 50 ] );</listing>
		 * 
		 * @example Using the factory method <code>createObject</code> of the class to create the instance : 
		 * <listing>PXCoreFactory.buildInstance( "com.package::SomeClass", ["someParam"], "createObject" );</listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function buildInstance( qualifiedClassName : String, args : Array = null, factoryMethod : String = null, singletonAccess : String = null ) : Object
		{
			var msg : String;
			var clazz : Class;

			try
			{
				clazz = getDefinitionByName(qualifiedClassName) as Class;
			} 
			catch ( e : Error )
			{
				msg = "'" + (clazz ? clazz : qualifiedClassName) + "' class is not available in current domain";
				PXDebug.FATAL(msg, this);
				throw( e );
			}

			var obj : Object;
	
			if ( factoryMethod )
			{
				if ( singletonAccess )
				{
					var inst : Object;
					
					try
					{
						inst = clazz[ singletonAccess ].call();
					} catch ( eFirst : Error ) 
					{
						msg = qualifiedClassName + "." + singletonAccess + "()' singleton access failed.";
						PXDebug.FATAL(msg, this);
						return null;
					}
					
					try
					{
						obj = inst[factoryMethod].apply(inst, args);
					} catch ( eSecond : Error ) 
					{
						msg = qualifiedClassName + "." + singletonAccess + "()." + factoryMethod + "()' factory method call failed.";
						PXDebug.FATAL(msg, this);
						return null;
					}
				} 
				else
				{
					try
					{
						obj = clazz[factoryMethod].apply(clazz, args);
					} catch( eThird : Error )
					{
						msg = qualifiedClassName + "." + factoryMethod + "()' factory method call failed.";
						PXDebug.FATAL(msg, this);
						return null;
					}
				}
			} else if ( singletonAccess )
			{
				try
				{
					obj = clazz[ singletonAccess ].call();
				} catch ( eFourth : Error ) 
				{
					msg = qualifiedClassName + "." + singletonAccess + "()' singleton call failed.";
					PXDebug.FATAL(msg, this);
					return null;
				}
			} 
			else
			{
				obj = _buildInstance(clazz, args);
			}

			return obj;
		}

		
		/**
		 * @private
		 * A map between number of arguments and buld function
		 */
		private const _A : Array = [_build0,_build1,_build2,_build3,_build4,_build5,_build6,_build7,_build8,_build9,
										_build10,_build11,_build12,_build13,_build14,_build15,_build16,_build17,_build18,_build19,
										_build20,_build21,_build22,_build23,_build24,_build25,_build26,_build27,_build28,_build29,
										_build30];

		
		/**
		 * @private
		 * Wrapping method which select which build method use
		 * according to the argument count.
		 */
		private function _buildInstance( clazz : Class, args : Array = null ) : Object
		{
			var f : Function = _A[ args ? args.length : 0 ];
			var _args : Array = [clazz];
			if ( args ) _args = _args.concat(args);
			return f.apply(null, _args);
		}
		
		/**
		 * @private
		 */
		private function _build0( clazz : Class ) : Object
		{ 
			return new clazz(); 
		}
		
		/**
		 * @private
		 */
		private function _build1( clazz : Class ,a1 : * ) : Object
		{ 
			return new clazz(a1); 
		}
		
		/**
		 * @private
		 */
		private function _build2( clazz : Class ,a1 : *,a2 : * ) : Object
		{ 
			return new clazz(a1, a2); 
		}
		
		/**
		 * @private
		 */
		private function _build3( clazz : Class ,a1 : *,a2 : *,a3 : * ) : Object
		{ 
			return new clazz(a1, a2, a3); 
		}
		
		/**
		 * @private
		 */
		private function _build4( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4); 
		}
		
		/**
		 * @private
		 */
		private function _build5( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5); 
		}
		
		/**
		 * @private
		 */
		private function _build6( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6); 
		}
		
		/**
		 * @private
		 */
		private function _build7( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7); 
		}
		
		/**
		 * @private
		 */
		private function _build8( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8); 
		}
		
		/**
		 * @private
		 */
		private function _build9( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9); 
		}
		
		/**
		 * @private
		 */
		private function _build10( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10); 
		}
		
		/**
		 * @private
		 */
		private function _build11( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11); 
		}
		
		/**
		 * @private
		 */
		private function _build12( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12); 
		}
		
		/**
		 * @private
		 */
		private function _build13( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13); 
		}
		
		/**
		 * @private
		 */
		private function _build14( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14); 
		}
		
		/**
		 * @private
		 */
		private function _build15( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15); 
		}
		
		/**
		 * @private
		 */
		private function _build16( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16); 
		}
		
		/**
		 * @private
		 */
		private function _build17( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17); 
		}
		
		/**
		 * @private
		 */
		private function _build18( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18); 
		}
		
		/**
		 * @private
		 */
		private function _build19( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19); 
		}
		
		/**
		 * @private
		 */
		private function _build20( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20); 
		}
		
		/**
		 * @private
		 */
		private function _build21( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21); 
		}
		
		/**
		 * @private
		 */
		private function _build22( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22); 
		}
		
		/**
		 * @private
		 */
		private function _build23( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23); 
		}
		
		/**
		 * @private
		 */
		private function _build24( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : *,a24 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24); 
		}
		
		/**
		 * @private
		 */
		private function _build25( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : *,a24 : *,a25 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25); 
		}
	
		/**
		 * @private
		 */
		private function _build26( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : *,a24 : *,a25 : *,a26 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26); 
		}
		
		/**
		 * @private
		 */
		private function _build27( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : *,a24 : *,a25 : *,a26 : *,a27 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27); 
		}
		
		/**
		 * @private
		 */
		private function _build28( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : *,a24 : *,a25 : *,a26 : *,a27 : *,a28 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28); 
		}
		
		/**
		 * @private
		 */
		private function _build29( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : *,a24 : *,a25 : *,a26 : *,a27 : *,a28 : *,a29 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29); 
		}
		
		/**
		 * @private
		 */
		private function _build30( clazz : Class ,a1 : *,a2 : *,a3 : *,a4 : *,a5 : *,a6 : *,a7 : *,a8 : *,a9 : *,a10 : *,a11 : *,a12 : *,a13 : *,a14 : *,a15 : *,a16 : *,a17 : *,a18 : *,a19 : *,a20 : *,a21 : *,a22 : *,a23 : *,a24 : *,a25 : *,a26 : *,a27 : *,a28 : *,a29 : *,a30 : * ) : Object
		{ 
			return new clazz(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30); 
		}
		
		static private  var _oI : PXCoreFactory ;

		private var _oEB : PXEventBroadcaster ;
		private var _mMap : PXHashMap ;

		/**
		 * Returns singleton instance.
		 * 
		 * @return singleton instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXCoreFactory
		{
			if ( !(PXCoreFactory._oI is PXCoreFactory) ) 
				PXCoreFactory._oI = new PXCoreFactory();
			return PXCoreFactory._oI;
		}
		
		/**
		 * Releases singleton instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function release() : void
		{
			if ( PXCoreFactory._oI is PXCoreFactory ) PXCoreFactory._oI = null;
		}
		
		/**
		 * @private
		 * Constructor
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXCoreFactory()
		{
			_oEB = new PXEventBroadcaster(this) ;
			_mMap = new PXHashMap() ;
		}
		
		/**
		 * Returns registered keys in factory.
		 * 
		 * @return registered keys in factory.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function  get keys() : Array
		{
			return _mMap.keys;
		}
		
		/**
		 * Returns registered values in factory.
		 * 
		 * @return registered values in factory.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getValues() : Array
		{
			return _mMap.values;
		}
		
		/**
		 * Clears all key/value association in factory.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			_mMap.clear();
		}
		
		/**
		 * Returns the ressource associated with the passed-in <code>key</code>.
		 * If there is no ressource identified by the passed-in key, the
		 * function will fail with an error. To avoid the throw of an exception
		 * when attempting to access to a ressource, take care to check the
		 * existence of the ressource before trying to access to it.
		 * 
		 * @param	key	identifier of the ressource to access
		 * 
		 * @return	the ressource associated with the passed-in <code>key</code>
		 * 
		 * @throws 	net.pixlib.exceptions.PXNoSuchElementException — There is no ressource
		 * 			associated with the passed-in key
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function locate( key : String ) : Object
		{
			if ( isRegistered(key) )
			{
				return _mMap.get(key) ;
			} 
			else
			{
				var msg : String = "locate(" + key + ") fails." ;
				throw new PXNoSuchElementException(msg, this);
			}
		}
		
		/**
		 * Returns <code>true</code> is there is a ressource associated
		 * with the passed-in <code>key</code>. To avoid errors when
		 * retreiving ressources you should systematically
		 * use the <code>isRegistered</code> function to check if the
		 * ressource you would access is already accessible before any
		 * call to the <code>locate</code> function.
		 * 
		 * @param key	Ressource identifier
		 * 
		 * @return 	<code>true</code> is there is a ressource associated
		 * 			with the passed-in <code>key</code>.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isRegistered( key : String ) : Boolean
		{
			return _mMap.containsKey(key) ;
		}
		
		/**
		 * Returns <code>true</code> is passed-in bean ressource is registered.
		 * 
		 * @param bean	Ressource to check
		 * 
		 * @return 	<code>true</code> if ressource is registered.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isBeanRegistered( bean : Object ) : Boolean
		{
			return _mMap.containsValue(bean) ;
		}
		
		/**
		 * Registers passed-in bean with key identifier.
		 * 
		 * @param key	Object identifier
		 * @param bean	Object to register
		 * 
		 * @return	<code>true</code> if registration is success.
		 * 
		 * @throws	net.pixlib.exceptions.PXIllegalArgumentException - A ressource 
		 * 			is already registered using passed-in key.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function register(key : String, bean : Object) : Boolean
		{
			if (!isRegistered(key))
			{
				_mMap.put(key, bean) ;
				_oEB.broadcastEvent(new PXCoreFactoryEvent(PXCoreFactoryEvent.onRegisterBeanEVENT, key, bean)) ;
				return true ;
			} 
			else
			{
				var msg : String = "";

				if (isRegistered(key))
				{
					msg += "register(" + key + ", " + bean + ") fails, key is already registered." ;
				}
				
				throw new PXIllegalArgumentException(msg, this);
				return false ;
			}
		}
		
		/**
		 * Unregisters ressource registered using passed-in key identifier.
		 * 
		 * @param key	Identifier to check.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function unregister(key : String) : Boolean
		{
			if ( isRegistered(key) )
			{
				_mMap.remove(key) ;
				_oEB.broadcastEvent(new PXCoreFactoryEvent(PXCoreFactoryEvent.onUnregisterBeanEVENT, key, null)) ;
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
		/**
		 * Unregisters passed-in ressource.
		 * 
		 * @param bean	Ressource to unregister
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function unregisterBean( bean : Object ) : Boolean
		{
			var key : String = getKey(bean);
			return ( key != null ) ? unregister(key) : false;
		}
		
		/**
		 * Returns the registration identifier of passed-in ressource.
		 * 
		 * @param bean	Ressource to check 
		 * 
		 * @return	ressource identifier or <code>null</code> if ressource is not 
		 * 			registered.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getKey( bean : Object ) : String
		{
			var key : String;
			var registered : Boolean = isBeanRegistered(bean);

			if (registered)
			{
				var keys : Array = _mMap.keys;
				var keysLength : uint = keys.length;

				while( --keysLength > -1 ) 
				{
					key = keys[ keysLength ];
					if ( locate(key) == bean ) return key;
				}
			}
			
			return null;
		}

		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this event broadcaster. The function returns <code>true</code>
		 * if the listener have been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * <p>
		 * Note : The <code>addListener</code> function doesn't accept functions
		 * as listener, functions could only register for a single event.
		 * </p>
		 * @param	listener	the listener object to add as global listener
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>PXIllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>PXIllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addListener( listener : PXCoreFactoryListener ) : Boolean
		{
			return _oEB.addListener(listener);
		}
		
		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * @throws 	<code>PXIllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeListener( listener : PXCoreFactoryListener ) : Boolean
		{
			return _oEB.removeListener(listener);
		}
		
		/**
		 * @copy net.pixlib.events.PXBroadcaster#addEventListener()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply(_oEB, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}
		
		/**
		 * @copy net.pixlib.events.PXBroadcaster#removeEventListener() 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener(type, listener);
		}
		
		/**
		 * Returns string representation of instance.
		 * 
		 * @return string representation of instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this);
		}
		
		/**
		 * Adds all ressources contained in the passed-in dictionnary
		 * into this instance. If there is keys used both in
		 * the locator and in the dictionnary an exception is thrown.
		 * 
		 * @param	dico	dictionnary instance which contains ressources
		 * 					to be added
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException — One or more
		 * 			keys present in the dictionnary already exist in this
		 * 			locator instance.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function add( dico : Dictionary ) : void
		{
			for ( var key : * in dico ) 
			{
				try
				{
					register(key, dico[ key ] as Object);
				} catch( e : PXIllegalArgumentException )
				{
					e.message = this + ".add() fails. " + e.message;
					PXDebug.ERROR(e.message, this);
					throw( e );
				}
			}
		}
	}
}