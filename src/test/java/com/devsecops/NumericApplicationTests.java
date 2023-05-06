// package com.devsecops;

// import org.junit.Test;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
// import org.springframework.boot.test.context.SpringBootTest;
// import org.springframework.test.web.servlet.MockMvc;

// import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
// import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
// //import org.junit.jupiter.api.Test;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
// import org.springframework.boot.test.context.SpringBootTest;
// import org.springframework.test.web.servlet.MockMvc;

// import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
// import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
// //import org.junit.Test;
// import org.junit.runner.RunWith;
// import org.springframework.test.context.junit4.SpringRunner;
// import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

// @RunWith(SpringRunner.class)
// @SpringBootTest
// @AutoConfigureMockMvc
// public class NumericApplicationTests {

//     @Autowired
//     private MockMvc mockMvc;

//     @Test
//     public void smallerThanOrEqualToFiftyMessage() throws Exception {
//         this.mockMvc.perform(get("/compare/50")).andDo(print()).andExpect(status().isOk())
//                 .andExpect(content().string("Smaller than or equal to 50"));
//     }

//     @Test
//     public void greaterThanFiftyMessage() throws Exception {
//         this.mockMvc.perform(get("/compare/51")).andDo(print()).andExpect(status().isOk())
//                 .andExpect(content().string("Greater than 50"));
//     }
    
    

//     @Test
//     public void welcomeMessage() throws Exception {
//         this.mockMvc.perform(get("/")).andDo(print()).andExpect(status().isOk())
//                 .andExpect(content().string("Kubernetes DevSecOps"));
//     }
    

// }

package com.devsecops;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;


@ExtendWith(SpringExtension.class)
@SpringBootTest
@AutoConfigureMockMvc
public class NumericApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void smallerThanOrEqualToFiftyMessage() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/compare/50"))
               .andDo(MockMvcResultHandlers.print())
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.content().string("Smaller than or equal to 50"));
    }

    @Test
    public void greaterThanFiftyMessage() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/compare/51"))
               .andDo(MockMvcResultHandlers.print())
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.content().string("Greater than 50"));
    }
    
    @Test
    public void welcomeMessage() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/"))
               .andDo(MockMvcResultHandlers.print())
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.content().string("Kubernetes DevSecOps"));
    }
}
