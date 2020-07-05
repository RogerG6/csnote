# pthread

## 0. 介绍

* Linux下的线程机制

  *  进程与线程之间是有区别的，不过[linux](http://lib.csdn.net/base/linux)内核只提供了轻量进程的支持，未实现线程模型。Linux是一种“多进程单线程”的[操作系统](http://lib.csdn.net/base/operatingsystem)。Linux本身只有进程的概念，而其所谓的“线程”本质上在内核里仍然是进程。<br>

    ​         大家知道，进程是资源分配的单位，同一进程中的多个线程共享该进程的资源（如作为共享内存的全局变量）。Linux中所谓的“线程”只是在被创建时clone了父进程的资源，因此clone出来的进程表现为“线程”，这一点一定要弄清楚。因此，Linux“线程”这个概念只有在打冒号的情况下才是最准确的。<br>

    ​        目前Linux中最流行的线程机制为LinuxThreads，所采用的就是线程－进程**“一对一”**模型，调度交给核心，而在用户级实现一个包括信号处理在内的线程管理机制。LinuxThreads由Xavier Leroy  (Xavier.Leroy@inria.fr)负责开发完成，并已绑定在GLIBC中发行，它实现了一种BiCapitalized面向Linux的Posix 1003.1c “pthread”标准接口。Linuxthread可以支持Intel、Alpha、MIPS等平台上的多处理器系统。 <br>

    

* 编译：gcc -o a a.c -lpthread<br>因为线程机制一开始Linux中是没有的，后来加进去的，所以是以库的形式存在的。<br>按照POSIX 1003.1c 标准编写的程序与Linuxthread 库相链接即可支持Linux平台上的多线程，在程序中需包含头文件pthread. h，在编译链接时需要加参数-lpthread 

## 1. pthread_creat/join

* creat : 创建一个新的线程
* join ：等待某线程终止

## 2. pthread_mutex_lock/unlock

* lock : 等待互斥锁解开后，在锁住互斥量
* unlock : 给互斥量解锁

## 3. pthread_cond_wait

* 功能：使线程挂起，等待某个条件变量的信号

* 实现（猜测）：

  1. release lock: 对互斥对象解锁，使得其他线程能够访问互斥量
  2. suspend && wait for cond：挂起，等待特定条件发生
  3. wait up：特定条件发生后，本函数被唤醒
  4. get lock：试图获取互斥对象锁

* Example

  ```c
  In thread1(main thread):
  		pthread_mutex_lock(&m_mutex);   
          pthread_cond_wait(&m_cond,&m_mutex);   
          pthread_mutex_unlock(&m_mutex);  
  In Thread2:
          pthread_mutex_lock(&m_mutex);   
          pthread_cond_signal(&m_cond);   
          pthread_mutex_unlock(&m_mutex);  
  
  
  
  ```

  * Qus1: 为什么要和pthread_mutex_lock/unlock一起使用<br>Ans1: 这是为了应对 线程1在调用pthread_cond_wait()但线程1还没有进入wait cond的状态的时候，此时线程2调用了cond_singal 的情况。 如果不用mutex锁的话，这个cond_singal就丢失了。加了锁的情况是，线程2必须等到 线程1 pthread_cod_wait的mutex  被释放后才能调用cond_singal

  * ````c
    In thread2:
    		// cond1:
            pthread_mutex_lock
                xxxxxxx
            pthread_cond_signal				// 在中间
            pthread_mutex_unlock
        	// cond2:
            pthread_mutex_lock
                xxxxxxx
            pthread_mutex_unlock
            pthread_cond_signal    			// 在unlock后
    ````

    Qus2：是使用cond1还是cond2 ？？

    Ans2：cond1: 缺点：在某下线程的实现中，会造成等待线程从内核中唤醒（由于cond_signal)然后又回到内核空间（因为cond_wait返回后会有原子加锁的 行为），所以一来一回会有性能的问题。但是在LinuxThreads或者NPTL里面，就不会有这个问题，因为在Linux  线程中，有两个队列，分别是cond_wait队列和mutex_lock队列，  cond_signal只是让线程从cond_wait队列移到mutex_lock队列，而不用返回到用户空间，不会有性能的损耗。<br>
    所以在Linux中推荐使用这种模式。<br>cond2: 优点：不会出现之前说的那个潜在的性能损耗，因为在signal之前就已经释放锁了<br>
    缺点：如果unlock和signal之前，有个低优先级的线程正在mutex上等待的话，那么这个低优先级的线程就会抢占高优先级的线程（cond_wait的线程)，而这在上面的放中间的模式下是不会出现的。s

    <br>**PS:我在测试过程中并未发现cond1中所说的有2个队列，调用cond_signal后我这里出现的情况是其他线程在竞争，并没有返回到cond_wait的线程中。<br>具体代码见：github: linux/uulp/test/thread/count/twocount4.c**</u>

## 4. pthread_cond_signal

* 功能：唤醒一个正在等待的线程