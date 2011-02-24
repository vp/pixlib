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
package net.pixlib.log.layout
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.log.PXLogEvent;
	import net.pixlib.log.PXLogLevel;
	import net.pixlib.log.PXLogListener;
	import net.pixlib.log.PXTraceLayout;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getQualifiedClassName;

	/**
	 * The PXFileLayout class provides a convenient way
	 * to output messages into a <strong>file</strong>.
	 * 
	 * <p>File is located under the application storage directory and named 
	 * like ".logs".</p>
	 * 
	 * <p>You can choose the writing process using first getInstance() call by 
	 * passing <code>true</code> or <code>false</code>. 
	 * Default is <code>true</code>.</p>
	 * 
	 * @example
	 * <listing>
	 * 
	 * PXLogManager.getInstance().addLogListener(PXFileLayout.getInstance(false));
	 * </listing>
	 * 
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogManager.html net.pixlib.log.PXLogManager
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogListener net.pixlib.log.PXLogListener
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogLevel net.pixlib.log.PXLogLevel
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXFileLayout implements PXLogListener
	{
		/**
		 * @private
		 */
		public static const DEBUG_PREFIX : String = PXTraceLayout.DEBUG_PREFIX;
		
		/**
		 * @private
		 */
		public static const INFO_PREFIX : String = PXTraceLayout.INFO_PREFIX;
		
		/**
		 * @private
		 */
		public static const WARN_PREFIX : String = PXTraceLayout.WARN_PREFIX;
		
		/**
		 * @private
		 */
		public static const ERROR_PREFIX : String = PXTraceLayout.ERROR_PREFIX;
		
		/**
		 * @private
		 */
		public static const FATAL_PREFIX : String = PXTraceLayout.FATAL_PREFIX;
		
		/**
		 * @private
		 */
		private static var _instance : PXFileLayout;
		
		/**
		 * @private 
		 */
		private var _mFormat : PXHashMap;
		
		/**
		 * @private
		 */
		private var _file : File;

		/**
		 * @private
		 */
		private var _stream : FileStream;
		
		/**
		 * Returns unique instance of PxFileLayout class.
		 * 
		 * @return the unique instance of PxFileLayout class.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getInstance(append : Boolean = true) : PXFileLayout
		{
			if (!_instance) _instance = new PXFileLayout(append);
			return _instance;
		}
		
		/**
		 * Release instance.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function release() : void
		{
			_instance._stream.close();
			_instance._stream = null;
			_instance._file = null;
			_instance = null;
		}
		
		/**
		 * Triggered when a log message has to be sent.(from the PXLogManager)
		 * 
		 * @param	event	The event containing information about 
		 * 					the message to log.
		 * 				
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onLog(event : PXLogEvent) : void
		{
			var prefix : String = _mFormat.get(event.level);
			var target : String = (event.logTarget != null) ? "[" + getQualifiedClassName(event.logTarget) + "]" : "";
			var time : String = "[" + new Date() + "] ";
			var flow : String = prefix + time + target + event.message + "\n";
			
			try
			{
				_stream.writeUTFBytes(flow);
			}
			catch(e : Error) {}
		}
		
		/**
		 * Not applied here.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onClear(event : Event = null) : void
		{
			
		}

		/**
		 * @private
		 */
		function PXFileLayout(append : Boolean = true)
		{
			_file = new File(File.applicationStorageDirectory.nativePath + "/.logs");
			_stream = new FileStream();
			_stream.open(_file, append ? FileMode.APPEND : FileMode.WRITE);
			
			_mFormat = new PXHashMap();
			_mFormat.put(PXLogLevel.DEBUG, DEBUG_PREFIX);
			_mFormat.put(PXLogLevel.INFO, INFO_PREFIX);
			_mFormat.put(PXLogLevel.WARN, WARN_PREFIX);
			_mFormat.put(PXLogLevel.ERROR, ERROR_PREFIX);
			_mFormat.put(PXLogLevel.FATAL, FATAL_PREFIX);
		}
	}
}
