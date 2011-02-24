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
	import net.pixlib.log.PXDebug;

	import flash.net.SharedObject;

	/**
	 * The PXSharedObjectUtils class provides basic methods 
	 * to save data on a local machine.
	 * 
	 * <p>The version doesn't handle remote SharedObject. It's not its goal.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Francis Bourre
	 * @author	Cédric Néhémie
	 */
	final public class PXSharedObjectUtils
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/** 
		 * Default root path for SharedObject file.
		 * 
		 * @default "/"
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var DEFAULT_ROOT_PATH : String = "/";

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
						
		/**
		 * Get a value stored in a local SharedObject.
		 * 
		 * <p>If an error occurs the function returns a null value.</p>
		 * 
		 * @param	cookieName	Name of the cookie.
		 * @param	objectName	Field to retrieve.
		 * @param	localPath	The full or partial path to the SWF file that 
		 * 						created the	shared object, and that determines 
		 * 						where the shared object will be stored locally. 
		 * 						If you do not specify this parameter, 
		 * 						the root "DEFAULT_ROOT_PATH" is used.
		 * @param	secure		Determines whether access to this shared object 
		 * 						is restricted to SWF files that are delivered 
		 * 						over an HTTPS connection.(default is false)	
		 * 									
		 * @return	 The value stored in the field or <code>null</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function loadLocal( cookieName : String, objectName : String, localPath : String = null, secure : Boolean = false ) : *
		{	
			try
			{
				if( localPath == null ) localPath = DEFAULT_ROOT_PATH;
				
				var save : SharedObject = SharedObject.getLocal(cookieName, localPath, secure);
				return save.data[objectName];
			} 
			catch( e : Error )			{
				PXDebug.ERROR(e, PXSharedObjectUtils);
				return null;
			}
		}

		/**
		 * Save some data in a local SharedObject.
		 * 
		 * <p>If an error occurs the function dies silently and data isn't saved.</p>
		 * 
		 * @param	cookieName	Name of the cookie.
		 * @param	objectName	Field to retreive.
		 * @param	refValue	Value to save.
		 * @param	localPath	The full or partial path to the SWF file that 
		 * 						created the	shared object, and that determines 
		 * 						where the shared object will be stored locally. 
		 * 						If you do not specify this parameter, 
		 * 						the root "DEFAULT_ROOT_PATH" is used.
		 * @param	secure		Determines whether access to this shared object 
		 * 						is restricted to SWF files that are delivered 
		 * 						over an HTTPS connection.(default is false)	
		 * 						
		 * @return	<code>true</code> if the data have been saved.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function saveLocal( cookieName : String, objectName : String, refValue : *, localPath : String = null, secure : Boolean = false ) : Boolean
		{
			try
			{
				if( localPath == null ) localPath = DEFAULT_ROOT_PATH;
				
				var save : SharedObject = SharedObject.getLocal(cookieName, localPath, secure);
				save.data[ objectName ] = refValue;
				save.flush();
				return true;
			} 
			catch( e : Error )
			{
				PXDebug.ERROR(e, PXSharedObjectUtils);
			}
			
			return false;
		}

		/**
		 * Clear all values stored in a local SharedObject.
		 * 
		 * <p>If an error occurs the function dies silently and returns false.</p>
		 * 
		 * @param	cookieName Name of the cookie.
		 * @param	localPath	The full or partial path to the SWF file that 
		 * 						created the	shared object, and that determines 
		 * 						where the shared object will be stored locally. 
		 * 						If you do not specify this parameter, 
		 * 						the root "DEFAULT_ROOT_PATH" is used.
		 * @param	secure		Determines whether access to this shared object 
		 * 						is restricted to SWF files that are delivered 
		 * 						over an HTTPS connection.(default is false)	
		 * 						
		 * @return	<code>true</code> if data has been cleared.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function clearLocal( cookieName : String, localPath : String = null, secure : Boolean = false ) : Boolean
		{
			try
			{
				if( localPath == null ) localPath = DEFAULT_ROOT_PATH;
				
				var save : SharedObject = SharedObject.getLocal(cookieName, localPath, secure);
				save.clear();
				
				return true;
			} 
			catch( e : Error )
			{
				PXDebug.ERROR(e, PXSharedObjectUtils);
			}
			
			return false;
		}

		/**
		 * @private
		 */
		function PXSharedObjectUtils( )
		{
		}
	}
}