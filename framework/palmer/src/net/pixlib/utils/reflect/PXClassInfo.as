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
package net.pixlib.utils.reflect 
{
	import net.pixlib.collections.PXArrayIterator;
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.collections.PXIterator;
	import net.pixlib.commands.PXDelegate;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.log.PXDebug;

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Provides class description.
	 * 
	 * @example
	 * <listing>>
	 *
	 * var info : PXClassInfo = PXClassInfo.describe( EventBroadcaster );
	 * PalmerDebug.INFO( info.toString( false ) );
	 *
	 * PalmerDebug.INFO( info.getContructor() );
	 * PalmerDebug.INFO( info.getAccessorIterator( ) );
	 * PalmerDebug.INFO( info.getPropertyIterator( ) );
	 * PalmerDebug.INFO( info.getConstantIterator( ) );
	 * PalmerDebug.INFO( info.getMethodIterator( ClassInfo.STATIC_FILTER ) );
	 *
	 * PalmerDebug.INFO( info.containsMethod( "addEventListener" ) );
	 * PalmerDebug.INFO( info.containsProperty( "otto" ) );
	 * PalmerDebug.INFO( info.containsAccessor( "enabled" ) );
	 * </listing>
	 *
	 * <p>Informations are cached, so if a <code>PXClassInfo</code> instance
	 * already exist for a class type, returns the cached instance.</p>
	 *
	 * @example
	 * <listing>
	 *
	 * var instance : PopupContextMenu = new PopupContextMenu(   );
	 *
	 * var info1 : PXClassInfo = PXClassInfo.describe( PopupContextMenu );
	 * var info2 : PXClassInfo = PXClassInfo.describe( PopupContextMenu );
	 * var info3 : PXClassInfo = PXClassInfo.describe( "flash.geom.Point" );
	 * var info4 : PXClassInfo = PXClassInfo.describe( new Sprite() );
	 * </listing>
	 * 
	 * <p>In this example, just only one <code>PXClassInfo</code> instance
	 * is created.</p>
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXClassInfo
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
           
		/** 
		 * Filter identifier to retreive all methods and properties (default).
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const NONE_FILTER : int = 0;

		/**
		 * Filter identifier to retreive static methods and properties.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const STATIC_FILTER : int = 1;

		/** 
		 * Filter identifier to retreive factory methods and properties.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const FACTORY_FILTER : int = 2;

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _mCache : PXHashMap = new PXHashMap();

		private var _xmlDesc : XML;
		private var _sFullName : String;
		private var _oType : Class;
		private var _aInterfaceList : Array;
		private var _aSuperList : Array;
		private var _oConstuctor : PXMethodInfo;
		private var _aMethodList : Array;
		private var _aAccessorList : Array;
		private var _aPropertyList : Array;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
           
		/**
		 * Linebreak for output display using <code>toString()</code> only.
		 * 
		 * @see #toString()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var LINEBREAK : String = "\n";

		/**
		 * Tab separator for output display using <code>toString()</code> only.
		 * 
		 * @see #toString()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var TAB : String = "\t";

		
		/** <code>true</code> if class is <code>static</code>. */
		public function get staticFlag( ) : Boolean
		{
			return _xmlDesc.@isStatic == "true" ? true : false;
		}

		/** <code>true</code> if class is <code>final</code>. */
		public function get finalFlag( ) : Boolean
		{
			return _xmlDesc.@isFinal == "true" ? true : false;
		}

		/** <code>true</code> if class is <code>dynamic</code>. */
		public function get dynamicFlag( ) : Boolean
		{
			return _xmlDesc.@isDynamic == "true" ? true : false;
		}

		/** Full qualified class name. */
		public function get fullQualifiedName( ) : String
		{
			return _sFullName;      
		}

		/** Class name. */
		public function get name( ) : String
		{
			return _sFullName.split("::").pop();
		}

		/** Class package. */
		public function get packageName( ) : String
		{
			if( _sFullName.indexOf("::") > -1 )
                           return _sFullName.split("::").shift();
                   else return "";
		}

		/** XML desciption. */
		public function get description() : XML 
		{ 
			return _xmlDesc; 
		}

		/** Class type. */
		public function get type() : Class 
		{ 
			return _oType; 
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
           
		/**
		 * Builds and returns <strong>ClassInfo</strong> instance for passed-in
		 * <code>o</code> object.
		 *
		 * <p>Informations are cached, so if a <strong>ClassInfo</strong>
		 * instance already exist for a class type, returns the cached
		 * instance.</p>
		 *
		 * <p><span class="label"><b>Overloading</b></span>
		 * <ul>
		 *   <li>ClassInfo.describe( PopupContextMenu )</li>
		 *   <li>ClassInfo.describe( new Sprite() )</li>
		 *   <li>ClassInfo.describe( "flash.geom.Point" )</li>
		 * </ul></p>
		 *
		 * @param 	o	Overloading support
		 *
		 * @throws 	<code>IllegalArgumentException</code> - <code>o</code> is 
		 * 			not a valid object to describe.
		 *
		 * @return	Class or instance informations
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function describe( target : Object ) : PXClassInfo
		{
			if( target is String )
			{
				try
				{
					target = getDefinitionByName(target as String);
				}
				catch( e : Error )
				{
					throw new PXIllegalArgumentException(target + " class is not loaded in context.", PXClassInfo);
					return null;    
				}
			}
			
			var clazzName : String = getQualifiedClassName(target);
			
			if( !_mCache.containsKey(clazzName) )
			{
				_mCache.put(clazzName, new PXClassInfo(target));      
			}
			
			return _mCache.get(clazzName) as PXClassInfo;
		}

		/**
		 * Releases <strong>ClassInfo</strong> instance for passed-in 
		 * <code>o</code> object.
		 *
		 * <p><span class="label"><b>Mixed types support</b></span>
		 * <ul>
		 *   <li>ClassInfo.release( PopupContextMenu )</li>
		 *   <li>ClassInfo.release( new PopupContextMenu() )</li>
		 *   <li>ClassInfo.release( "fever.ui.menu.PopupContextMenu" )</li>
		 * </ul></p>
		 *
		 * @param	o	Object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function release( target : Object ) : void
		{
			if( target is String )
			{
				try
				{
					target = getDefinitionByName(target as String);
				}
				catch( e : Error )
				{
					PXDebug.ERROR(target + " class is not loaded in context.", PXClassInfo);
					return;
				}
			}
            
			var clazzName : String = getQualifiedClassName(target);
                   
			if( _mCache.containsKey(clazzName) )
			{
				var info : PXClassInfo = _mCache.remove(clazzName) as PXClassInfo;
				info._clean();
			}
		}

		/**
		 * Builds and returns instance of current class.
		 *
		 * @param	aArgs			arguments to apply to instanciation process
		 * @param	factoryMethod	factory method to use for instanciation
		 * @param	singletonAccess	singleton method to use for instanciation
		 *
		 * @throws	<code>NoSuchElementException</code> - <code>factoryMethod</code> 
		 * 			or <code>singletonAccess</code> parameters are defined 
		 * 			and not implemented in current class.<br />
		 * 			<code>static</code> flag test is done for 
		 * 			<code>singletonAccess</code> method name.
		 *
		 * @return	New instance of current class type
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function buildInstance( 
				arguments : Array = null,
                factoryMethod : String = null,
                singletonAccess : String = null ) : Object
		{
			if( factoryMethod != null && !containsMethod(factoryMethod) )
			{
				throw new PXNoSuchElementException("'" + factoryMethod + "( )'" + " method is not implemented in " + fullQualifiedName);
				return null;
			}
                   
			if( singletonAccess != null )
			{
				var method : PXMethodInfo = getMethod(singletonAccess);
                           
				if( method != null )
				{
					if( !method.staticFlag )
					{
						throw new PXNoSuchElementException("'" + singletonAccess + "( )'" + " method is not static in " + fullQualifiedName);
                                           
						return null;    
					}
				}
				else
				{
					throw new PXNoSuchElementException("'" + singletonAccess + "( )'" + " method is not implemented in " + fullQualifiedName);
                                           
					return null;    
				}
			}
            
			return PXCoreFactory.getInstance().buildInstance(fullQualifiedName, arguments, factoryMethod, singletonAccess);
		}

		/**
		 * Returns extended super classes list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getSuperClasseList( ) : Array
		{
			return _aSuperList;
		}

		/**
		 * Returns extended super classes list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getSuperClasseIterator( ) : PXIterator
		{
			return new PXArrayIterator(_aSuperList);        
		}

		/**
		 * Returns implemented interfaces list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getInterfaceList() : Array
		{
			return _aInterfaceList;
		}

		/**
		 * Returns implemented interfaces iterator.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getInterfaceIterator( ) : PXIterator
		{
			return new PXArrayIterator(_aInterfaceList);    
		}

		/**
		 * Returns constructor information.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getConstructor( ) : PXMethodInfo
		{
			return _oConstuctor;
		}

		/**
		 * Returns class methods list.
		 *
		 * <p>Uses <code>filter</code> to retreive all methods, static methods
		 * or only factory methods.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 * @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Array = info.getMethodList();
		 *      var staticAndParent : Array = info.getMethodList( ClassInfo.STATIC_FILTER, true );
		 *      var staticOnlyOwner : Array = info.getMethodList( ClassInfo.STATIC_FILTER, false );
		 *      var factoryAndParent : Array = info.getMethodList( ClassInfo.FACTORY_FILTER, true );
		 *      var factoryOnlyOwner : Array = info.getMethodList( ClassInfo.FACTORY_FILTER, false );
		 * </pre>
		 *
		 * @param	filter		filtering method
		 * @param	inheritance	<code>true</code> to show elements in all 
		 * 						extends classes too, <code>false</code> 
		 * 						to filter current class only implementation.
		 *
		 * @return	Method list according passed-in filters
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getMethodList( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : Array
		{
			if(filter == STATIC_FILTER)
			{
				return _aMethodList.filter(PXDelegate.create(_getStatic, inheritance));
			}
			else if(filter == FACTORY_FILTER)
			{
				return _aMethodList.filter(PXDelegate.create(_getFactory, inheritance));
			}
			
			return  _aMethodList.filter(PXDelegate.create(_getInheritance, inheritance));
		}

		/**
		 * Returns class methods iterator.
		 *
		 * <p>Uses <code>filter</code> to retreive all methods, static methods
		 * or only factory methods.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 * @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Iterator = info.getMethodIterator();
		 *      var staticAndParent : Iterator = info.getMethodIterator( ClassInfo.STATIC_FILTER, true );
		 *      var staticOnlyOwner : Iterator = info.getMethodIterator( ClassInfo.STATIC_FILTER, false );
		 *      var factoryAndParent : Iterator = info.getMethodIterator( ClassInfo.FACTORY_FILTER, true );
		 *      var factoryOnlyOwner : Iterator = info.getMethodIterator( ClassInfo.FACTORY_FILTER, false );
		 * </pre>
		 *
		 * @param	filter		filtering method
		 * @param	inheritance	<code>true</code> to show elements in all 
		 * 						extends classes too, <code>false</code> 
		 * 						to filter current class only implementation
		 *
		 * @return	an iterator throw methods collection
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getMethodIterator( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : PXIterator
		{
			return new PXArrayIterator(getMethodList(filter, inheritance));
		}

		/**
		 * Returns class accessors list.
		 *
		 * <p>Uses <code>filter</code> to retreive all accessors, static accessors
		 * or only factory accessors.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 * @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Array = info.getAccessorList();
		 *      var staticAndParent : Array = info.getAccessorList( ClassInfo.STATIC_FILTER, true );
		 *      var staticOnlyOwner : Array = info.getAccessorList( ClassInfo.STATIC_FILTER, false );
		 *      var factoryAndParent : Array = info.getAccessorList( ClassInfo.FACTORY_FILTER, true );
		 *      var factoryOnlyOwner : Array = info.getAccessorList( ClassInfo.FACTORY_FILTER, false );
		 * </pre>
		 *
		 * @param	filter		filtering method
		 * @param	inheritance	<code>true</code> to show elements in all 
		 * 						extends classes too, <code>false</code> 
		 * 						to filter current class only implementation.
		 *
		 * @return	accessor list according passed-in filters
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getAccessorList( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : Array
		{
			if(filter == STATIC_FILTER)
			{
				return _aAccessorList.filter(PXDelegate.create(_getStatic, inheritance));
			}
			else if(filter == FACTORY_FILTER)
			{
				return _aAccessorList.filter(PXDelegate.create(_getFactory, inheritance));
			}
			
			return _aAccessorList.filter(PXDelegate.create(_getInheritance, inheritance));
		}

		/**
		 * Returns class accessors iterator.
		 *
		 * <p>Uses <code>filter</code> to retreive all accessors, static accessors
		 * or only factory accessors.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 * @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Iterator = info.getAccessorIterator();
		 *      var staticAndParent : Iterator = info.getAccessorIterator( ClassInfo.STATIC_FILTER, true );
		 *      var staticOnlyOwner : Iterator = info.getAccessorIterator( ClassInfo.STATIC_FILTER, false );
		 *      var factoryAndParent : Iterator = info.getAccessorIterator( ClassInfo.FACTORY_FILTER, true );
		 *      var factoryOnlyOwner : Iterator = info.getAccessorIterator( ClassInfo.FACTORY_FILTER, false );
		 * </pre>
		 *
		 * @param	filter		filtering method
		 * @param	inheritance	<code>true</code> to show elements in all 
		 * 			extends classes too, <code>false</code> to filter current 
		 * 			class only implementation
		 *
		 * @return	an iterator throw accessors collection
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getAccessorIterator( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : PXIterator
		{
			return new PXArrayIterator(getAccessorList(filter, inheritance));
		}

		/**
		 * Returns class properties list.
		 *
		 * <p>Uses <code>filter</code> to retreive all properties,
		 * static properties or only factory properties.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 * @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Array = info.getPropertyList();
		 *      var staticProperties : Array = info.getPropertyList( ClassInfo.STATIC_FILTER );
		 *      var factoryProperties : Array = info.getPropertyList( ClassInfo.FACTORY_FILTER );
		 * </pre>
		 *
		 * @param	filter	filtering method
		 *
		 * @return	properties list according passed-in filters
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getPropertyList( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : Array
		{
			var arr : Array = _aPropertyList.filter(_isProperty);
			
			if(filter == STATIC_FILTER)
			{
				return arr.filter(PXDelegate.create(_getStatic, inheritance));
			}
			else if(filter == FACTORY_FILTER)
			{
				return arr.filter(PXDelegate.create(_getFactory, inheritance));
			}
			
			return arr;
		}

		/**
		 * Returns class properties iterator.
		 *
		 * <p>Uses <code>filter</code> to retreive all properties,
		 * static properties or only factory properties.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 *  @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Iterator = info.getPropertyIterator();
		 *      var staticProperties : Iterator = info.getPropertyIterator( ClassInfo.STATIC_FILTER );
		 *      var factoryProperties : Iterator = info.getPropertyIterator( ClassInfo.FACTORY_FILTER );
		 * </pre>
		 *
		 * @param	filter	filtering method
		 *
		 * @return	an iterator throw properties collection
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getPropertyIterator( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : PXIterator
		{
			return new PXArrayIterator(getPropertyList(filter, inheritance));
		}

		/**
		 * Returns class constants list
		 *
		 * <p>Uses <code>filter</code> to retreive all constants,
		 * static constants or only factory constants.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 * @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Array = info.getContantList();
		 *      var staticProperties : Array = info.getContantList( ClassInfo.STATIC_FILTER );
		 *      var factoryProperties : Array = info.getContantList( ClassInfo.FACTORY_FILTER );
		 * </pre>
		 *
		 * @param	filter	filtering method
		 *
		 * @return	constants list according passed-in filters
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getContantList( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : Array
		{
			var arr : Array = _aPropertyList.filter(_isConstant);
            
			if(filter == STATIC_FILTER)
			{
				return arr.filter(PXDelegate.create(_getStatic, inheritance));
			}
            else if(filter == FACTORY_FILTER)
			{
				return arr.filter(PXDelegate.create(_getFactory, inheritance));
			}
            
			return arr;
		}

		/**
		 * Returns class constants iterator.
		 *
		 * <p>Uses <code>filter</code> to retreive all constants,
		 * static constants or only factory constants.
		 * <ul>
		 *   <li>ClassInfo.NONE_FILTER ( default )</li>
		 *   <li>ClassInfo.STATIC_FILTER</li>
		 *   <li>ClassInfo.FACTORY_FILTER</li>
		 * </ul></p>
		 *
		 * @example
		 * <pre class="prettyprint">
		 *      
		 *      var info : ClassInfo = ClassInfo.describe( EventBroadcaster );
		 *      var all : Iterator = info.getConstantIterator();
		 *      var staticProperties : Iterator = info.getConstantIterator( ClassInfo.STATIC_FILTER );
		 *      var factoryProperties : Iterator = info.getConstantIterator( ClassInfo.FACTORY_FILTER );
		 * </pre>
		 *
		 * @param	filter	filtering method
		 *
		 * @return	an iterator throw constants collection
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getConstantIterator( filter : Number = NONE_FILTER, inheritance : Boolean = true ) : PXIterator
		{
			return new PXArrayIterator(getContantList(filter, inheritance));
		}

		/**
		 * Returns <code>true</code> if passed-in <code>accessor</code>
		 * name is defined by current class.
		 *
		 * @param	accessor	name of the accessor to search
		 *
		 * @return	<code>true</code> if passed-in <code>accessor</code> 
		 * 			name is defined by current class, either <code>false</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function containsAccessor( accessor : String ) : Boolean
		{
			return _containsElementName(getAccessorIterator(), accessor);
		}

		/**
		 * Returns <code>true</code> if passed-in <code>method</code>
		 * name is defined by current class.
		 *
		 * @param	method	name of the method to search
		 *
		 * @return	<code>true</code> if passed-in <code>method</code> name 
		 * 			is defined by current class, either <code>false</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function containsMethod( method : String ) : Boolean
		{
			return _containsElementName(getMethodIterator(), method);
		}

		/**
		 * Returns <code>true</code> if passed-in <code>property</code>
		 * name is defined by current class.
		 *
		 * @param	property	name of the property to search
		 *
		 * @return	<code>true</code> if passed-in <code>property</code> name 
		 * 			is defined by current class, either <code>false</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function containsProperty( property : String ) : Boolean
		{
			return _containsElementName(getPropertyIterator(), property);
		}

		/**
		 * Returns <strong>MethodInfo</strong> of method defined by passed-in
		 * <code>method</code> name.
		 *
		 * @param	method	name of the method to search
		 *
		 * @return	information about method ( or <code>null</code> )
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getMethod( method : String ) : PXMethodInfo
		{
			return  _getElementByName(getMethodIterator(), method) as PXMethodInfo;
		}

		/**
		 * Returns <strong>PropertyInfo</strong> of property defined by passed-in
		 * <code>property</code> name.
		 *
		 * @param	property	name of the property to search
		 *
		 * @return	information about property ( or <code>null</code> )
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getProperty( property : String ) : PXPropertyInfo
		{
			return  _getElementByName(getPropertyIterator(), property) as PXPropertyInfo;
		}

		/**
		 * Returns <strong>PropertyInfo</strong> of constant defined by 
		 * passed-in <code>constant</code> name.
		 *
		 * @param	constant	name of the constant to search
		 *
		 * @return	information about constant ( or <code>null</code> )
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getConstant( constant : String ) : PXPropertyInfo
		{
			return  _getElementByName(getConstantIterator(), constant) as PXPropertyInfo;
		}

		/**
		 * Returns <strong>AccessorInfo</strong> of accessor defined by 
		 * passed-in <code>accessor</code> name.
		 *
		 * @param	accessor	name of the accessor to search
		 *
		 * @return	information about accessor ( or <code>null</code> )
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getAccessor( accessor : String ) : PXAccessorInfo
		{
			return  _getElementByName(getAccessorIterator(), accessor) as PXAccessorInfo;
		}

		/**
		 * Returns string representation.
		 *
		 * @see #LINEBREAK
		 * @see #TAB
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString( inheritance : Boolean = true ) : String
		{
			var result : String = "";
                   
			result += "Name " + name + LINEBREAK;
			result += "Package " + packageName + LINEBREAK;
			result += "Extends " + getSuperClasseList() + LINEBREAK;
			result += "Implements " + getInterfaceList() + LINEBREAK;
                   
			result += "Constants" + LINEBREAK;
			result += _stringify(getConstantIterator());
                   
			result += "Properties" + LINEBREAK;
			result += _stringify(getPropertyIterator());
                   
			result += "Accessors" + LINEBREAK;
			result += _stringify(getAccessorIterator(NONE_FILTER, inheritance));

			if( _oConstuctor != null )
			{
				result += "Constructor" + LINEBREAK;
				result += ( TAB + getConstructor().toString() + LINEBREAK );
			}
                   
			result += "Methods" + LINEBREAK;
			result += _stringify(getMethodIterator(NONE_FILTER, inheritance));

			return result;
		}

		
		//--------------------------------------------------------------------
		// Private implementations
		//--------------------------------------------------------------------
           
		/**
		 * @private
		 * Constuctor.
		 */
		function PXClassInfo( o : Object)
		{
			_sFullName = getQualifiedClassName(o);
                   
			_oType = ( o is Class ) ? (o as Class) : getDefinitionByName(_sFullName) as Class;
                   
			_xmlDesc = describeType(_oType);
            
			_buildSuperClass();
			_buildInterfaces();
			_buildConstructor();
			_buildMethods();

			_buildAccesssors();
			_buildProperties();
		}
		
		/**
		 * @private
		 */
		private function _buildSuperClass() : void
		{
			var xmlList : XMLList = _xmlDesc.factory.extendsClass.@type;
                   
			_aSuperList = new Array();
                   
			if( xmlList.length() > 0 )
			{
				for each( var name : XML in xmlList )
				{
					_aSuperList.push(name.toString());
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _buildInterfaces() : void
		{
			var xmlList : XMLList = _xmlDesc.factory.implementsInterface.@type;
                   
			_aInterfaceList = new Array();
                   
			if( xmlList.length() > 0 )
			{
				for each( var name : XML in xmlList )
				{
					_aInterfaceList.push(name.toString());
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _buildConstructor() : void
		{
			if( _xmlDesc.factory.constructor[0] != null )
			{
				_oConstuctor = new PXMethodInfo(_xmlDesc.factory.constructor[0]);  
			}
			else
			{
				_oConstuctor = null;
			}
		}
		
		/**
		 * @private
		 */
		private function _buildMethods() : void
		{
			var xmlList : XMLList = _xmlDesc.factory.method;
                   
			_aMethodList = new Array();
                   
			if( xmlList.length() > 0 )
			{
				for each( var node : XML in xmlList )
				{
					_aMethodList.push(new PXMethodInfo(node));
				}
			}
                   
			if( staticFlag )
			{
				xmlList = _xmlDesc.method;      
				if( xmlList.length() > 0 )
				{
					for each( var node2 : XML in xmlList )
					{
						_aMethodList.push(new PXMethodInfo(node2, true));
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _buildAccesssors() : void
		{
			var xmlList : XMLList = _xmlDesc.factory.accessor;
                   
			_aAccessorList = new Array();
                   
			if( xmlList.length() > 0 )
			{
				for each( var node : XML in xmlList )
				{
					_aAccessorList.push(new PXAccessorInfo(node));
				}
			}
            
			if( staticFlag )
			{
				xmlList = _xmlDesc.accessor;    
				if( xmlList.length() > 0 )
				{
					for each( var node2 : XML in xmlList )
					{
						if( node2.@name != 'prototype' )
                                                   _aAccessorList.push(new PXAccessorInfo(node2, true));
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _buildProperties() : void
		{
			var xmlList : XMLList = _xmlDesc.factory.variable;
                   
			_aPropertyList = new Array();
                   
			if( xmlList.length() > 0 )
			{
				for each( var node : XML in xmlList )
				{
					_aPropertyList.push(new PXPropertyInfo(node));
				}
			}
            
			if( staticFlag )
			{
				xmlList = _xmlDesc.variable;    
                           
				if( xmlList.length() > 0 )
				{
					for each( var node2 : XML in xmlList )
					{
						_aPropertyList.push(new PXPropertyInfo(node2, true));
					}
				}
			}
                   
			_buildConstants();
		}
		
		/**
		 * @private
		 */
		private function _buildConstants() : void
		{
			var xmlList : XMLList = _xmlDesc.factory.constant;
                   
			if( xmlList.length() > 0 )
			{
				for each( var node : XML in xmlList )
				{
					_aPropertyList.push(new PXPropertyInfo(node, false, true));
				}
			}
			
			if( staticFlag )
			{
				xmlList = _xmlDesc.constant;    
				if( xmlList.length() > 0 )
				{
					for each( var node2 : XML in xmlList )
					{
						_aPropertyList.push(new PXPropertyInfo(node2, true, true));
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _stringify( list : PXIterator ) : String
		{
			var result : String = '';
                   
			while( list.hasNext() )
			{
				result += ( TAB + list.next().toString() + LINEBREAK );
			}
                   
			return result;
		}
		
		/**
		 * @private
		 */
		private function _getStatic( element : PXElementInfo, index : int, arr : Array, inheritance : Boolean ) : Boolean
		{
			if( !inheritance )
			{
				return ( (element.staticFlag == true) && (element.declaredBy == fullQualifiedName) );
			}
                   
			return element.staticFlag == true;
		}
		
		/**
		 * @private
		 */
		private function _getFactory( element : PXElementInfo, index : int, arr : Array, inheritance : Boolean ) : Boolean
		{
			if( !inheritance )
			{
				return ( (element.staticFlag == false) && (element.declaredBy == fullQualifiedName) );
			}
			
			return element.staticFlag == false;
		}
		
		/**
		 * @private
		 */
		private function _getInheritance( element : PXElementInfo, index : int, arr : Array, inheritance : Boolean ) : Boolean
		{
			if( !inheritance )
			{
				return ( element.declaredBy == fullQualifiedName );
			}
                   
			return true;
		}
		
		/**
		 * @private
		 */
		private function _isProperty( element : PXPropertyInfo, ...rest ) : Boolean
		{
			return ( element.constantFlag == false );
		}
		
		/**
		 * @private
		 */
		private function _isConstant( element : PXPropertyInfo, ...rest ) : Boolean
		{
			return ( element.constantFlag == true );
		}
		
		/**
		 * @private
		 */
		private function _containsElementName( list : PXIterator, sName : String ) : Boolean
		{
			while( list.hasNext() )
			{
				if( ( list.next() as PXElementInfo ).name == sName )
                                   return true;    
			}
            
			return false;
		}
		
		/**
		 * @private
		 */
		private function _getElementByName( list : PXIterator, sName : String ) : PXElementInfo
		{
			while( list.hasNext() )
			{
				var obj : PXElementInfo = list.next() as PXElementInfo;
                           
				if( obj.name == sName ) return obj;        
			}
                   
			return null;
		}
		
		/**
		 * @private
		 */
		private function _clean() : void
		{
			_xmlDesc = null;
			_sFullName = null;
			_oType = null;
			_aInterfaceList = null;
			_aSuperList = null;
			_oConstuctor = null;
			_aMethodList = null;
			_aAccessorList = null;
			_aPropertyList = null;
		}
	}
}