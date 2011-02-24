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
package net.pixlib.load
{
	import net.pixlib.commands.PXCommand;
	import net.pixlib.load.strategy.PXLoadStrategy;

	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * The PXLoader interface defines rules for Pixlib loaders implementations.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 * @author 	Romain Ecarnot
	 */
	public interface PXLoader extends PXCommand
	{
		/**
		 * The URL used by this loader.
		 * 
		 * <p>If 'anticache' or 'prefix' are used, returns the full 
		 * qualified url.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get request() : URLRequest;
		
		/**
		 * @private
		 */
		function set request(value : URLRequest) : void;
		
		/**
		 * The URL passed to the loader instance prefix.
		 * 
		 * @example
		 * <listing>
		 * 
		 * var loader : PXLoader = new PXFileLoader();
		 * loader.prefix = "config/context/";
		 * loader.load( new URLRequest( "info.txt" ) );
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		function get prefix() : String;
		
		/**
		 * @private
		 */
		function set prefix(value : String) : void;
		
		/**
		 * The loader's identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get name() : String;
		
		/**
		 * @private
		 */
		function set name(value : String) : void;
		
		/**
		 * The percentage of loaded bytes.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get percentLoaded() : Number;
		
		/**
		 * The loaded state.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get loaded() : Boolean;
		
		/**
		 * The loading strategy used by the loader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get strategy() : PXLoadStrategy;
		
		/**
		 * Indicates if an anticache system must be used.
		 * 
		 * <p>Sets anticache to <code>true</code> to add timestamp value 
		 * to the loaded URL. In this way, it force the re loading of content and 
		 * not use the possible cache content.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get anticache() : Boolean;
		
		/**
		 * @private
		 */
		function set anticache(value : Boolean) : void;
		
		/**
		 * The loaded content.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get content( ) : Object;
		
		/**
		 * @private
		 */
		function set content(value : Object) : void;
		
		/**
		 * The LoaderContext instance to use for this loader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get context( ) : LoaderContext;
		
		/**
		 * @private
		 */
		function set context(value : LoaderContext) : void;

		/**
		 * Loads content.
		 * 
		 * @param	loadingRequest	The absolute or relative URL of the content to load.
		 * @param	loadingContext	(optional) A LoaderContext object, which has 
		 * 							properties that define the following: 
		 * <ul>
		 * 	<li>Whether or not to check for the existence of a policy file upon loading the object</li>
		 * 	<li>The ApplicationDomain for the loaded object</li>
		 * 	<li>The SecurityDomain for the loaded object</li>
		 * </ul>
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function load(loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : void;
		
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
		 * 
		 * @param	listener	the listener object to add as global listener.
		 * 
		 * @return	<code>true</code> if the listener have been added during this call.
		 * 
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			is a function
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function addListener( listener : PXLoaderListener ) : Boolean;

		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object.
		 * 						
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			is a function.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function removeListener( listener : PXLoaderListener ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXBroadcaster#addEventListener()
		 */
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;

		/**
		 * @copy net.pixlib.events.PXBroadcaster#removeEventListener()
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;

		/**
		 * Dispatches event during loading progression.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function fireOnLoadProgressEvent() : void;

		/**
		 * Dispatches event when the loading is finished.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function fireOnLoadInitEvent() : void;

		/**
		 * Dispatches event when the loading starts.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function fireOnLoadStartEvent() : void;

		/**
		 * Dispatches event when an error occur.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function fireOnLoadErrorEvent( message : String = null ) : void;
		
		/**
		 * Releases loader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function release() : void
		
		/**
		 * Returns string representation of loader.
		 * 
		 * @return The string representation of loader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function toString() : String
	}
}