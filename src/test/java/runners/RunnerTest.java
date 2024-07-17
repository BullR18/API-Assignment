package runners;

import com.intuit.karate.junit5.Karate;

    class RunnerTest {

        @Karate.Test
        Karate testAll() {
            return Karate.run("classpath:features/OrdersAPI.feature");
        }

        @Karate.Test
        Karate testTags() {
            return Karate.run("classpath:features").tags("@GET_ORDER_BY_ID");
        }
    }

