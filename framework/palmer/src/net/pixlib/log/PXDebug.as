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
package net.pixlib.log 
{
	import net.pixlib.events.PXEventChannel;

	/**
	 * The PXDebug class is the default Pixlib PXLog.
	 * 
	 * <p>All internal framework message were sent throw this channel.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public final class PXDebug implements PXLog
	{
		/**
		 * @private
		 */
		static private var _oI : PXDebug;
		
		/**
		 * @private
		 */
		public const ownChannel : PXEventChannel = new PXPixlibDebugChannel();
		
		/**
		 * @private
		 */
		protected var bIsOn : Boolean;
		
		/**
		 * @private
		 */
		function PXDebug()
		{
			activate();
		}
		
		/**
		 * Returns singleton instance.
		 * 
		 * @return singleton instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXLog
		{
			if ( !( _oI is PXDebug ) ) _oI = new PXDebug();
			return _oI;
		}
		
		/**
		 * @copy net.pixlib.log.PXLog#debug
		 */
		static public function DEBUG( o : *, target : Object = null ) : void
		{
			PXDebug.getInstance().debug( o, target );
		}
		
		/**
		 * @copy net.pixlib.log.PXLog#info
		 */
		static public function INFO( o : *, target : Object = null ) : void
		{
			PXDebug.getInstance().info( o, target );
		}
		
		/**
		 * @copy net.pixlib.log.PXLog#warn
		 */
		static public function WARN( o : *, target : Object = null ) : void
		{
			PXDebug.getInstance().warn( o, target );
		}
		
		/**
		 * @copy net.pixlib.log.PXLog#error
		 */
		static public function ERROR( o : *, target : Object = null ) : void
		{
			PXDebug.getInstance().error( o, target );
		}
		
		/**
		 * @copy net.pixlib.log.PXLog#fatal
		 */
		static public function FATAL( o : *, target : Object = null ) : void
		{
			PXDebug.getInstance().fatal( o, target );
		}
		
		/**
		 * @copy net.pixlib.log.PXLog#clear
		 */
		static public function CLEAR(  ) : void
		{
			PXDebug.getInstance().clear( );
		}
		
		/**
		 * @inheritDoc
		 */
		public function debug(o : *, target : Object = null) : void
		{
			if ( activated ) PXLogManager.DEBUG ( o, ownChannel, target );
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(o : *, target : Object = null) : void
		{
			if ( activated ) PXLogManager.INFO ( o, ownChannel, target );
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(o : *, target : Object = null) : void
		{
			if ( activated ) PXLogManager.WARN ( o, ownChannel, target );
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(o : *, target : Object = null) : void
		{
			if ( activated ) PXLogManager.ERROR ( o, ownChannel, target );
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(o : *, target : Object = null) : void
		{
			if ( activated ) PXLogManager.FATAL ( o, ownChannel, target );
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear( ) : void
		{
			if ( activated ) PXLogManager.CLEAR( ownChannel );
		}
		
		/**
		 * @inheritDoc
		 */
		public function get channel() : PXEventChannel
		{
			return ownChannel;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get activated() : Boolean
		{
			return bIsOn;
		}
		
		/**
		 * @inheritDoc
		 */
		public function activate() : void
		{
			bIsOn = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function desactivate() : void
		{
			bIsOn = false;
		}
	}
}

import net.pixlib.events.PXEventChannel;

internal class PXPixlibDebugChannel extends PXEventChannel {}