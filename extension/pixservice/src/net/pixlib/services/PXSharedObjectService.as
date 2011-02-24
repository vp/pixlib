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
package net.pixlib.services 
{
	import net.pixlib.core.PXValueObject;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.utils.PXObjectUtils;

	import flash.events.Event;
	import flash.net.SharedObject;

	/**
	 * Command implementation to use Flash <strong>SharedObject</strong> as service.
	 * 
	 * @example
	 * <listing>
	 * 
	 * public function test( ) : void
	 * {
	 * 	var service : PXSharedObjectService = new PXSharedObjectService( "config.user.name", "/" );
	 * 	service.addlistener( this );
	 * 	service.execute();
	 * }
	 * 
	 * public function onDataResult ( event : PXServiceEvent ) : void
	 * {
	 * 	var result : Object = event.service.result;
	 * }
	 * </listing>
	 * 
	 * @see PIXLIB_DOC/net/pixlib/services/PXService.html net.pixlib.service.PXService
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 * @author Francis Bourre
	 */
	public class PXSharedObjectService extends PXAbstractService
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _helper : PXSharedObjectServiceHelper;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * The name of the object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get name( ) : String
		{
			return _helper.name;		
		}

		/**
		 * The shared object path.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get localPath(  ) : String
		{
			return _helper.localPath;
		}

		/**
		 * Restricted to HTTPS connection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get secured(  ) : Boolean
		{
			return _helper.secure;
		}
		
		/**
		 * Service call result.
		 * 
		 * <p>If a data deserializer is defined, the result is the result 
		 * of deserialization process.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function set result( response : Object ) : void
		{
			var arr : Array = name.split(".");
			if ( arr.length > 1 ) 
			{
				arr.splice(0, 1);
				response = PXObjectUtils.evalFromTarget(response, arr.join("."));
			}
			
			super.result = response;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * @param	name		The name of the object.
		 * @param	localPath	The full or partial path to the SWF file that 
		 * 						created the	shared object, and that determines 
		 * 						where the shared object will be stored locally. 
		 * 						If you do not specify this parameter, 
		 * 						the root "/" is used.
		 * 	@param	secure		Determines whether access to this shared object 
		 * 						is restricted to SWF files that are delivered 
		 * 						over an HTTPS connection.(default is false)
		 * 						
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXSharedObjectService( name : String = "", localPath : String = "/", secure : Boolean = false )
		{
			super();
			helper = new PXSharedObjectServiceHelper(name, localPath, secure);
		}

		/**
		 * @private
		 */
		override protected function onExecute( event : Event = null ) : void
		{
			super.onExecute(event);

			if ( _helper is PXSharedObjectServiceHelper )
			{
				try
				{					var obj : SharedObject = SharedObject.getLocal.apply(null, getRemoteArguments());
					onResultHandler(obj.data);
				} 
				catch( e : Error )
				{
					logger.error(this + " call failed !. " + e.message + "\n" + e.getStackTrace(), this);
					onFaultHandler(null);
				}
			} 
			else
			{
				throw new PXNullPointerException(".execute() failed. Can't retrieve valid execution helper.", this);
			}
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------

		/**
		 * Sets the service heler to use by this servce.
		 * 
		 * @param helper A PXSharedObjectServiceHelper instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function set helper( value : PXValueObject ) : void
		{
			_helper = value as PXSharedObjectServiceHelper;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function getRemoteArguments() : Array
		{
			return [name.split(".")[0], localPath, secured];
		}
	}
}