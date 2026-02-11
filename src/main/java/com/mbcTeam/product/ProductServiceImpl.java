package com.mbcTeam.product;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mbcTeam.user.ReviewVO;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductDao dao;

    @Transactional
    @Override
    public void insert(ProductVO vo) {
        dao.insert(vo);
    }
    
    @Override
    public void insertImg(ProductImgVO ivo) {
        dao.insertImg(ivo);
    }
    
    @Override
    public void insertDescImg(ProductDescImgVO divo) {
    	dao.insertDescImg(divo);
    }

    @Override
    public void insertOption(ProductOptionVO option) {
        dao.insertOption(option);
    }

    @Override
    public void update(ProductVO vo) {
        dao.update(vo);
    }

    @Override
    public void delete(ProductVO vo) {
        dao.delete(vo);
    }

    @Override
    public List<ProductVO> select(ProductVO vo) {
        return dao.select(vo);
    }

    @Override
    public ProductVO edit(ProductVO vo) {
        return dao.edit(vo);
    }

    @Override
    public ProductVO detail(int productIdx) {
        return dao.detail(productIdx);
    }

    @Override
    public List<ProductOptionVO> selectOptions(int productIdx) {
        return dao.selectOptions(productIdx);
    }

    @Override
    public List<ReviewVO> selectReviews(int productIdx) {
        return dao.selectReviews(productIdx);
    }

    
    @Override
    public List<ProductVO> selectAll() {
        return dao.selectAll();
    }

    @Override
    public List<ProductVO> selectByCategory(String category) {
        return dao.selectByCategory(category);
    }

    @Override
    public List<ProductVO> selectByCategoryAndSub(String category, String subCategory) {
        return dao.selectByCategoryAndSub(category, subCategory);
    }



	@Override
	public int totalCount(ProductVO vo) {
		return dao.totalCount(vo);
	}

	@Override
	public List<ProductVO> adminSelect(ProductVO vo) {
		return dao.adminSelect(vo);
	}

	@Override
	public void adminUpdateProductStatus(ProductVO vo) {
		dao.adminUpdateProductStatus(vo);
		
	}

	@Override
	public ProductVO adminProductEdit(ProductVO vo) {
		return dao.adminProductEdit(vo);
	}

	@Override
	public List<ProductImgVO> adminProductEditImg(int productIdx) {
		return dao.adminProductEditImg(productIdx);
	}

	@Override
	public List<ProductDescImgVO> adminProductEditDescImg(int productIdx) {
		return dao.adminProductEditDescImg(productIdx);
	}

	@Override
	public List<ProductOptionVO> adminProductEditOption(int productIdx) {
		return dao.adminProductEditOption(productIdx);
	}

	@Override
	public ProductImgVO adminOneImg(int productImgIdx) {
		return dao.adminOneImg(productImgIdx);
	}

	@Override
	public ProductDescImgVO adminOneDescImg(int productDescImgIdx) {
		return dao.adminOneDescImg(productDescImgIdx);
	}

	@Override
	public void deleteImg(int productImgIdx) {
		dao.deleteImg(productImgIdx);
		
	}

	@Override
	public void deleteDescImg(int productDescImgIdx) {
		dao.deleteDescImg(productDescImgIdx);
		
	}
	
	@Override
	public void deleteOption(int optionIdx) {
		dao.deleteOption(optionIdx);
	}

	@Override
	public void updateImgOrder(ProductImgVO vo) {
		dao.updateImgOrder(vo);
		
	}

	@Override
	public void updateDescImgOrder(ProductDescImgVO vo) {
		dao.updateDescImgOrder(vo);
		
	}
	
	@Override
	public void updateOption(ProductOptionVO vo) {
		dao.updateOption(vo);
		
	}

	@Override
	public int imgCount(int productIdx) {
		return dao.imgCount(productIdx);
	}

	@Override
	public int descImgCount(int productIdx) {
		return dao.descImgCount(productIdx);
	}

	
	@Override
	public List<ProductVO> getRecommendedProducts() {
	    return dao.getRecommendedProducts();
	}

	@Override
	public List<ProductVO> getSaleProducts() {
	    return dao.getSaleProducts();
	}

	@Override
	public List<ProductVO> searchProducts(String keyword) {
	    return dao.searchProducts(keyword);
	}




}
