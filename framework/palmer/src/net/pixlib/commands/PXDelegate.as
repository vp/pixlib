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
package net.pixlib.commands
{
	import net.pixlib.transitions.PXTickListener;

	import flash.events.Event;

	/**
	 * The PXDelegate encapsulate a method call as an object. 
	 * The PXDelegate class provides two ways to encapsulate a method call :
	 * <ul>
	 * <li>By creating a new PXDelegate instance you can wrap the call into
	 * a command object.</li>	 * <li>By calling the <code>PXDelegate.create</code> method you can get
	 * an anonymous function which will encapsulate the call.</li>
	 * </ul>
	 * 
	 * @author	Francis Bourre
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXDelegate extends PXAbstractCommand implements PXTickListener
	{
		protected var fHandler : Function;
		
		[ArrayElementType("Object")] 
		protected var aArguments : Array;
		
		protected var bHasEventCallback : Boolean;

		
		/**
		 * Creates a anonymous function which will wrap the call
		 * to the passed-in function with the passed-in <code>rest</code>
		 * as arguments to the function.
		 * 
		 * @param	method	specified method to encapsulate
		 * @param	args	additionall arguments to pass to pass 
		 * 					to the method
		 * @return	an anonymous function which will wrap the call
		 * 			to the passed-in function 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function create( method : Function, ... args ) : Function 
		{
			return function( ... rest ) : * {
				return method.apply(null, rest.length > 0 ? (args.length > 0 ? rest.concat(args) : rest) : (args.length > 0 ? args : null));
			};
		}
		
		/**
		 * Creates a new PXDelegate instance which encapsulate the call
		 * to the passed-in function with the passed-in <code>rest</code>
		 * as arguments to the function.
		 * 
		 * @param	method	specified method to encapsulate
		 * @param	rest	additionall arguments to pass to pass 
		 * 					to the method
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXDelegate( method : Function, ... rest )
		{
			fHandler = method;
			aArguments = rest;
			bHasEventCallback = true;
		}
		
		/**
		 * If <code>true</code> the event passed to the execute
		 * function will not be appended to the function arguments.
		 * 
		 * @param b	<code>true</code> to bypass the event to be
		 * 			appended to the function arguments
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function bypassEventCallback( value : Boolean ) : void
		{
			bHasEventCallback = !value;
		}
		
		/**
		 * Returns the current array of arguments which will be
		 * passed to the function when called.
		 * 
		 * @return 	array of arguments which will be
		 * 			passed to the function
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getArguments() : Array
		{
			return aArguments;
		}

		/**
		 * Defines the arguments to pass to the function
		 * 
		 * @param	rest	arguments to pass to the function
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) aArguments = rest;
		}

		/**
		 * Defines the arguments to pass to the function
		 * 
		 * @param	arguments	array of arguments to pass to the function
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setArgumentsArray( arguments : Array ) : void
		{
			if ( arguments.length > 0 ) aArguments = arguments;
		}

		/**
		 * Appends arguments to the current function's arguments.
		 * 
		 * @param	rest	arguments to append to the function's arguments.
		 * 					arguments
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addArguments( ... rest ) : void
		{
			if ( rest.length > 0 ) aArguments = aArguments.concat(rest);
		}

		/**
		 * Appends arguments to the current function's arguments.
		 * 
		 * @param	arguments	array of arguments to append to the function's 
		 * 						arguments
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addArgumentsArray( arguments : Array ) : void
		{
			if ( arguments.length > 0 ) aArguments = aArguments.concat(arguments);
		}

		/**
		 * Realizes the function call with the arguments defined
		 * in this PXDelegate object.
		 * <p>
		 * The receive event will be append to the arguments array
		 * except if the <code>bypassEvenCallback</code> have been
		 * called with <code>true</code> as argument.
		 * </p>
		 * @param	event	event object to append to the arguments
		 * 					array
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onExecute( event : Event = null ) : void
		{
			var a : Array = event != null && bHasEventCallback ? [event] : [];
			fHandler.apply(null, ( aArguments.length > 0 ) ? a.concat(aArguments) : ((a.length > 0 ) ? a : null));
			fireCommandEndEvent();
		}

		/**
		 * @inheritDoc
		 */
		public function onTick( event : Event = null ) : void
		{
			execute(event);
		}
		
		/**
		 * Allow the delegate object to be added as listener
		 * for any event type on any object which provide the
		 * <code>addEventListener</code>.
		 * 
		 * @param	event	event object dispatched with the event
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function handleEvent( event : Event ) : void
		{
			this.execute(event);
		}

		/**
		 * Calls the function with the current array of arguments.
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function callFunction() : *
		{
			return fHandler.apply(null, aArguments);
		}
	}
}